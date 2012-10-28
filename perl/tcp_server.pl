use strict;
use warnings;
use Socket;
use IO::Socket;

my $s = new IO::Socket::INET(
    LocalAddr => "127.0.0.1:10000",
    Proto => "tcp",
    ReuseAddr => 1,
    );

if (!$s) {
    die $!;
}

$s->listen();

while (1) {
    my $io = $s->accept();
    my $pid = fork();
    die "fork() failed" unless defined $pid;
    if ($pid == 0) {
        $pid = fork();
        if ($pid == 0) {
            server_main($io);
        } elsif ($pid == -1) {
            print "fork() failed: $!\n";
        }
        exit;
    } else {
        waitpid($pid, 0);
    }
}

sub server_main {
    my $io = shift;
    my $peer_sa = $io->peername();
    my ($port, $iaddr) = sockaddr_in($peer_sa);
    my $addr = inet_ntoa($iaddr);
    $io->print("Hello, $addr:$port!\n");
    $io->close();
}

1;

