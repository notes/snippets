use strict;
use warnings;

main() unless caller(0);

sub main {
    for my $arg (@ARGV) {
        print read_file_all($arg);
    }
}

sub read_file_all {
    my $filename = shift;
    open(my $fp, "<", $filename) or die $!;
    my $data = read_all($fp);
    close $fp or die $!;
    return $data;
}

sub read_all {
    my $handle = shift;
    local $/ = undef;
    return scalar <$handle>;
}
