#!/usr/bin/perl

use strict;
use warnings;
use Time::localtime qw();

our @DAY_OF_WEEK = qw(Sun Mon Tue Wed Thu Fri Sat);
our @MONTH_NAME = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);

print format_822date(time), "\n";
print format_iso8601(time), "\n";
print format_asctime(time), "\n";

sub format_822date {
    my $t = Time::localtime::localtime(shift);
    return sprintf("%s, %d %s %04d %02d:%02d:%02d %+03d00",
        $DAY_OF_WEEK[$t->wday], $t->mday, $MONTH_NAME[$t->mon],
        $t->year + 1900, $t->hour, $t->min, $t->sec, timezone_offset() / 3600);
}

sub format_iso8601 {
    my $t = Time::localtime::localtime(shift);
    return sprintf("%04d-%02d-%02dT%02d:%02d:%02d%+03d:00",
        $t->year + 1900, $t->mon, $t->mday, $t->hour, $t->min, $t->sec,
        timezone_offset() / 3600);
}

sub format_asctime {
    use POSIX qw(tzname);
    my $t = Time::localtime::localtime(shift);
    my @tznames = tzname();
    return sprintf("%s %s %2d %02d:%02d:%02d %s %04d",
        $DAY_OF_WEEK[$t->wday], $MONTH_NAME[$t->mon], $t->mday,
        $t->hour, $t->min, $t->sec,
        $t->isdst ? $tznames[1] : $tznames[0], $t->year + 1900);
}

sub timezone_offset {
    use Time::Local qw(timegm timelocal);
    my @t = localtime(time);
    return timegm(@t) - timelocal(@t);
}


