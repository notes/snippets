use strict;
use warnings;

for my $arg (@ARGV) {
    next if $arg !~ /^--/;
    my ($opt, $value) = split(/=/, $arg, 2);
    if (defined $value) {
        # with optarg
        if ($opt eq "--hello") {
            print "Hello, ${value}!\n";
        } elsif ($opt eq "--bye") {
            print "Bye, ${value}!\n";
        } else {
            usage();
        }
    } else {
        # boolean flag only
        if ($opt eq "--foo-flag") {
            print "foo\n";
        } elsif ($opt eq "--bar-flag") {
            print "bar\n";
        } else {
            usage();
        }
    }
}

sub usage {
    print <<"USAGE";
main [options]
  --hello=HELLO
  --bye=BYE
  --foo-flag
  --bar-flag
USAGE
}
