use Getopt::Std;

my %opts;
$Getopt::Std::STANDARD_HELP_VERSION = 1;
sub VERSION_MESSAGE {
    print "Version 0.1\n";
}
sub HELP_MESSAGE {
    print "Help!\n";
}

getopts("mn:", \%opts);
if ($opts{m}) {
    print "option m\n";
}
if ($opts{n}) {
    print "option n = $opts{n}\n";
}
