#include <iostream>
#include <chrono>
#include <ratio>
#include <cstdio>
#include <ctime>

namespace chrono = std::chrono;
using chrono::system_clock;

template <typename Duration>
void systemClockToString(char *buffer, size_t bufferLen, chrono::time_point<system_clock, Duration>& t)
{
  // clock => time_t => struct tm => snprintf()が最善
  // 秒未満の端数が不要ならstrftime()でもよい
  auto unixTime = system_clock::to_time_t(t);
  std::tm wcTime;
  localtime_r(&unixTime, &wcTime);

  // 端数を求めるには必要な単位にcastして余りを取る
  auto timeInMs = chrono::duration_cast<chrono::microseconds>(t.time_since_epoch());
  int fraction = timeInMs.count() % decltype(timeInMs)::period::den;

  std::snprintf(buffer, bufferLen, "%04d-%02d-%02d %02d:%02d:%02d.%06d",
                wcTime.tm_year + 1900, wcTime.tm_mon + 1, wcTime.tm_mday,
                wcTime.tm_hour, wcTime.tm_min, wcTime.tm_sec, fraction);
}

template <typename Duration>
system_clock::time_point cutTimePortion(chrono::time_point<system_clock, Duration>& t)
{
  // ローカル時刻に変換して
  auto unixTime = system_clock::to_time_t(t);
  std::tm wcTime;
  localtime_r(&unixTime, &wcTime);
  // 日未満の端数を取り除いて
  wcTime.tm_sec = 0;
  wcTime.tm_min = 0;
  wcTime.tm_hour = 0;
  // system_clockに戻す
  auto newUnixTime = mktime(&wcTime);
  return system_clock::from_time_t(newUnixTime);
}

int main(int argc, const char **argv)
{
  // 現在時刻を取得
  auto now = system_clock::now();

  // 時間未満を切り捨て
  auto thisHour = chrono::time_point_cast<chrono::hours>(now);

  // タイムゾーンをGMTとして日未満を切り捨て
  // Epochが00:00:00であることを仮定している
  auto today = chrono::time_point_cast<chrono::duration<long, std::ratio<86400>>>(now);

  // Epochに関係なくローカルタイムゾーンで日未満を切り捨て
  auto localToday = cutTimePortion(now);

  // 文字列に変換
  using char30 = char[30];
  char30 nowTimestamp, hourTimestamp, todayTimestamp, localTodayTimestamp;
  systemClockToString(nowTimestamp, sizeof nowTimestamp, now);
  systemClockToString(hourTimestamp, sizeof hourTimestamp, thisHour);
  systemClockToString(todayTimestamp, sizeof todayTimestamp, today);
  systemClockToString(localTodayTimestamp, sizeof localTodayTimestamp, localToday);

  std::cout << nowTimestamp << std::endl;
  std::cout << hourTimestamp << std::endl;
  std::cout << todayTimestamp << std::endl;
  std::cout << localTodayTimestamp << std::endl;

  return 0;
}


