#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

main() unless caller(0);

sub main {
    my $stats = list_pid_stat();
    print Dumper $stats;
}

sub list_pid_stat {
    my $pids = list_pid();
    my %stats;
    for my $pid (@$pids) {
        my $stat = read_pid_stat($pid);
        $stats{$pid} = $stat;
    }
    return \%stats;
}

sub list_pid {
    opendir(my $proc, "/proc") or die $!;
    my @pids = <$proc>;
    closedir($proc) or die $!;
    return \@pids;
}

sub read_pid_stat {
    my $pid = shift;
    open(my $stat_fp, '<', "/proc/${pid}/stat") or die $!;
    my @stat_array = split(/\s+/, <$stat_fp>);
    close($stat_fp) or die $!;
    if (@stat_array < 38) {
        return undef;
    }
    my %stat;
    @stat{qw(
        cmd     state   ppid    pgrp    session ttynr   minflt
        cminflt mayflt  cmayflt utime   stime   cutime  cstime
        prior   nice    nlwp    sttime  vsize   nswap   cnswap
        cpu
    )} = @stat_array[1..6,9..19,21..22,35..36,38];
    return \%stat;
}

