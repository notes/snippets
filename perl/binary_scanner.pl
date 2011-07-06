use strict;

my $buffer;
read(STDIN, $buffer, 4096);

# scan uint8 * 4
my ($c1, $c2, $c3, $c4) = unpack("CCCC", $buffer);
print "8bit: $c1 $c2 $c3 $c4\n";

# scan uint16 * 2 in big-endian
my ($s1, $s2) = unpack("nn", $buffer);
print "16bit: $s1 $s2\n";

# scan uint32 in big-endian
my $i = unpack("N", $buffer);
print "32bit: $i\n";

# scan uint64 in big-endian
# note that "Q" is 64-bit in native byte-order
my ($q1, $q2) = unpack("NN", $buffer);
printf "64bit: %llu\n", $q1*(2**32) + $q2;
