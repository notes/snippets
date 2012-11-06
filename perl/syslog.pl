#!/usr/bin/perl

use strict;
use warnings;
use IO::Socket;
use POSIX qw(locale_h strftime);

our %facility = (
    kern   => 0,
    user   => 1,
    mail   => 2,
    daemon => 3,
    auth   => 4,
    syslog => 5,
    lpr    => 6,
    news   => 7,
    uucp   => 8,
    cron   => 9,
    auth2  => 10,
    ftp    => 11,
    ntp    => 12,
    auth3  => 13,
    auth4  => 14,
    cron2  => 15,
    local0 => 16,
    local1 => 17,
    local2 => 18,
    local3 => 19,
    local4 => 20,
    local5 => 21,
    local6 => 22,
    local7 => 23,
);

our %severity = (
    emerg   => 0,
    alert   => 1,
    crit    => 2,
    err     => 3,
    warning => 4,
    notice  => 5,
    info    => 6,
    debug   => 7,
);

main() unless caller(0);

sub main {
    my $log = IO::Socket::UNIX->new(Peer => "/var/run/syslog",
                                    Type => SOCK_DGRAM)
        or die $!;
    syslog($log, "user", "notice", "test");
    close $log or die $!;
}

sub priority {
    my ($facility, $severity) = @_;
    my $facility_code = $facility{lc $facility};
    my $severity_code = $severity{lc $severity};
    $facility_code = 1 unless defined $facility_code;
    $severity_code = 6 unless defined $severity_code;
    return ($facility_code * 8) + $severity_code;
}

sub syslog_timestamp {
    my $unixtime = shift;
    my $locale_save = setlocale(LC_TIME);
    setlocale(LC_TIME, "C");
    my $timestamp = strftime("%b %e %H:%M:%S", localtime($unixtime));
    setlocale(LC_TIME, $locale_save);
    return $timestamp;
}

sub syslog {
    return syslog_bsd(@_[(0,1,2)], undef, $_[3]);
}

sub syslog_bsd {
    # http://tools.ietf.org/html/rfc3164
    my ($socket, $facility, $severity, $unixtime, $message) = @_;
    my $priority = priority($facility, $severity);
    if (defined $unixtime) {
        my $timestamp = syslog_timestamp($unixtime);
        $message = "<$priority>$timestamp $message";
    } else {
        $message = "<$priority>$message";
    }
    $message = substr($message, 0, 1024) if length($message) > 1024;
    print $socket $message;
}

