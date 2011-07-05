use strict;
use Socket;
use IO::Socket;

my $buffer;
my $buffer_size = 4096;

my $s = new IO::Socket::INET(
    LocalAddr => "127.0.0.1:10000",
    Proto => "udp",
    ReuseAddr => 1);
if (!$s) {
    die $!;
}

while (1) {
    my $peer_sa = $s->recv($buffer, $buffer_size);
    if (!$peer_sa) {
        die $!;
    }
    my ($port, $iaddr) = sockaddr_in($peer_sa);
    my $addr = inet_ntoa($iaddr);
    chomp($buffer);
    print "From $addr:$port [$buffer]\n";
}

exit(0);

