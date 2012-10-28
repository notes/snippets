use strict;
use warnings;
use Socket;

main() unless caller(0);

sub main {
    my $pid = fork();
    die $! unless defined $pid;
    if ($pid == 0) {
        # child
        my $c = client();
        print $c "Hello, World!\n";
        close $c;
    } else {
        # parent
        my $s = server();
        my $peeraddr = accept(my $ss, $s) or die $!;
        my $data;
        {
            local $/ = undef;
            $data = <$ss>;
        }
        close $ss or die $!;
        print "In server: ${data}";
        close $s;
    }
}

sub server {
    socket(my $s, PF_INET, SOCK_STREAM, 0) or die $!;
    setsockopt($s, SOL_SOCKET, SO_REUSEADDR, 1) or die $!;
    my $sockaddr = sockaddr_in(8080, INADDR_ANY);
    bind($s, $sockaddr) or die $!;
    listen($s, 10) or die $!;
    return $s;
}

sub client {
    socket(my $c, PF_INET, SOCK_STREAM, 0) or die $!;
    my $addr = inet_aton("127.0.0.1");
    my $sockaddr = sockaddr_in(8080, $addr);
    connect($c, $sockaddr) or die $!;
    return $c;
}

