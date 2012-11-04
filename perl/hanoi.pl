#!/usr/bin/perl

use strict;
use warnings;

main() unless caller(0);

sub main {
    my $print_moving = sub {
        my ($disk_no, $from_peg, $to_peg) = @_;
        print "Move disk-${disk_no} from peg-${from_peg} to peg-${to_peg}\n";
    };
    hanoi(10, "A", "C", "B", $print_moving);
}

sub hanoi {
    my ($n, $start, $end, $extra, $callback) = @_;
    if ($n == 1) {
        $callback->(1, $start, $end);
    } else {
        hanoi($n - 1, $start, $extra, $end, $callback);
        $callback->($n, $start, $end);
        hanoi($n - 1, $extra, $end, $start, $callback);
    }
}
