use strict;
use warnings;
use Socket;
use IO::Socket;

main() unless caller(0);

sub main {
    my $listen_addr = "127.0.0.1:10000";
    my $sock = new IO::Socket::INET(
        LocalAddr => $listen_addr,
        Proto => "tcp",
        ReuseAddr => 1,
    );

    die "Failed to create socket: $!" unless defined $sock;
    die "Failed to listen ${listen_addr}: $!" unless $sock->listen();
    print "Started to listen connection on ${listen_addr}\n";

    while (1) {
        my $io = $sock->accept();
        unless ($io) {
            warn "Failed to accept connection: $!";
            next;
        }
        my $pid = fork();
        die "Failed to fork child process: $!" unless defined $pid;
        if ($pid == 0) {
            # child
            $pid = fork();
            die "Failed to fork child process: $!" unless defined $pid;
            if ($pid == 0) {
                # server process (child)
                server_main($io);
            }
            exit;
        } else {
            # parent
            waitpid($pid, 0);
        }
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

