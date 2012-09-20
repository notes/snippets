use strict;
use warnings;
use Carp;
use Getopt::Long qw(:config no_auto_abbrev);

my %opts;
{
  local $SIG{__WARN__} = sub { croak $_[0]; };
  GetOptions(\%opts, "string-opt=s", "integer-opt=i", "bool-opt");
}

croak "--string-opt missing" unless exists $opts{"string-opt"};
croak "--integer-opt missing" unless exists $opts{"integer-opt"};

my ($str, $int, $bool) = @opts{qw(string-opt integer-opt bool-opt)};
$bool = 1 unless defined $bool;

print "string-opt: $str\n";
print "integer-opt: $int\n";
print "bool-opt: $bool\n";

