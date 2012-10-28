use strict;
use warnings;
use Data::Dumper;

main() unless caller(0);

sub main {
    my $config_filename = shift @ARGV or die "please specify filename";
    my $config = read_config($config_filename);
    print Dumper $config;
}

sub read_config {
    my $filename = shift;
    my %config;
    open(my $fp, "<", $filename) or die $!;
    while (my $line = <$fp>) {
        $line =~ s/\A\s*//;
        $line =~ s/\s*\z//;
        next if $line =~ /\A\#/;
        my ($name, $value) = split(/\s*=\s*/, $line, 2);
        die "syntax error: ${line}" unless defined $name && defined $value;
        $config{lc $name} = $value;
    }
    close $fp or die $!;
    return \%config;
}
