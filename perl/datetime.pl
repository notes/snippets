#!/usr/bin/perl

use strict;
use warnings;
use List::Util;
use Time::localtime qw();
use Time::Local qw(timegm timelocal);

our @DAY_OF_WEEK = qw(Sun Mon Tue Wed Thu Fri Sat);
our @MONTH_NAME = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);

print format_822date(time), "\n";
print format_3339date(time), "\n";
print format_generalized_time(time), "\n";
print format_asctime(time), "\n";
print parse_822date(format_822date(time)), "\n";
print parse_3339date(format_3339date(time)), "\n";
print parse_generalized_time(format_generalized_time(time)), "\n";

sub format_822date {
    my $t = Time::localtime::localtime(shift);
    return sprintf("%s, %d %s %04d %02d:%02d:%02d %+03d00",
        $DAY_OF_WEEK[$t->wday], $t->mday, $MONTH_NAME[$t->mon],
        $t->year + 1900, $t->hour, $t->min, $t->sec, timezone_offset() / 3600);
}

sub parse_822date {
    my $time = shift;
    my $pattern = qr/
        \A
        (?P<wday>\w{3}),  \s+                          # day-of-week
        (?P<mday>\d{1,2}) \s+                          # day-of-month
        (?P<month>\w{3})  \s+                          # month name
        (?P<year>\d{4})   \s+                          # 4-digit year
        (?P<hour>\d{2}):(?P<min>\d{2}):(?P<sec>\d{2})  # hour-min-sec
        (?: \s+ (?P<tzoffset>[+-]\d{4}) )?             # timezone offset
        \z
    /x;
    return undef unless $time =~ $pattern;

    my ($wday, $mday, $month, $year, $hour, $min, $sec, $tzoffset) =
        @+{qw(wday mday month year hour min sec tzoffset)};
    my $imonth = List::Util::first {
        uc($MONTH_NAME[$_]) eq uc($month) 
    } 0..$#MONTH_NAME;
    return undef unless defined $imonth;

    if (defined $tzoffset) {
        my $gmt = timegm($sec, $min, $hour, $mday, $imonth, $year);
        return $gmt - ($tzoffset / 100) * 3600
    } else {
        return timelocal($sec, $min, $hour, $mday, $imonth, $year);
    }
}

# RFC 3339 contains a profile of ISO 8601 for Internet use.
sub format_3339date {
    my $t = Time::localtime::localtime(shift);
    return sprintf("%04d-%02d-%02dT%02d:%02d:%02d%+03d:00",
        $t->year + 1900, $t->mon + 1, $t->mday, $t->hour, $t->min, $t->sec,
        timezone_offset() / 3600);
}

sub parse_3339date {
    my $time = shift;
    my $pattern = qr/
        \A
        (?P<year>\d{4})-(?P<month>\d{2})-(?P<mday>\d{2})T  # year-month-mday
        (?P<hour>\d{2}):(?P<min>\d{2}):(?P<sec>\d{2})      # hour-min-sec
        (?:\.(?P<fraction>\d+))?                           # fraction
        (?P<tzoffset>Z|[+-]\d{2}:\d{2})?                   # timezone offset
        \z
    /x;
    return undef unless $time =~ $pattern;

    my ($mday, $month, $year, $hour, $min, $sec, $tzoffset) =
        @+{qw(mday month year hour min sec tzoffset)};
    if (defined $tzoffset) {
        my $gmt = timegm($sec, $min, $hour, $mday, $month - 1, $year);
        if ($tzoffset eq 'Z') {
            return $gmt;
        }
        return $gmt - substr($tzoffset, 0, 3) * 3600;
    } else {
        return timelocal($sec, $min, $hour, $mday, $month - 1, $year);
    }
}

# RFC 4517 contains the definition of LDAP Generalized Time syntax.
sub format_generalized_time {
    my $t = Time::localtime::localtime(shift);
    return sprintf("%04d%02d%02d%02d%02d%02d%+03d00",
        $t->year + 1900, $t->mon + 1, $t->mday, $t->hour, $t->min, $t->sec,
        timezone_offset() / 3600);
}

sub parse_generalized_time {
    my $time = shift;
    my $pattern = qr/
        \A
        (?P<year>\d{4})(?P<month>\d{2})(?P<mday>\d{2})  # year-month-mday
        (?P<hour>\d{2})(?P<min>\d{2})(?P<sec>\d{2})     # hour-min-sec
        (?:[.:](?P<fraction>\d+))?                      # fraction
        (?P<tzoffset>Z|[+-]\d{4})?                      # timezone offset
        \z
    /x;
    return undef unless $time =~ $pattern;

    my ($mday, $month, $year, $hour, $min, $sec, $tzoffset) =
        @+{qw(mday month year hour min sec tzoffset)};
    if (defined $tzoffset) {
        my $gmt = timegm($sec, $min, $hour, $mday, $month - 1, $year);
        if ($tzoffset eq 'Z') {
            return $gmt;
        }
        return $gmt - substr($tzoffset, 0, 3) * 3600;
    } else {
        return timelocal($sec, $min, $hour, $mday, $month - 1, $year);
    }
}

sub format_asctime {
    my $t = Time::localtime::localtime(shift);
    return sprintf("%s %s %2d %02d:%02d:%02d %04d",
        $DAY_OF_WEEK[$t->wday], $MONTH_NAME[$t->mon], $t->mday,
        $t->hour, $t->min, $t->sec, $t->year + 1900);
}

sub timezone_offset {
    my @t = localtime(time);
    return timegm(@t) - timelocal(@t);
}


