use strict;
use warnings;
use IO::Socket;

main() unless caller(0);

sub main {
    my $server_addr = shift @ARGV;
    my $server_port = 80;
    my $path = shift @ARGV || "/";
    my $server = "${server_addr}:${server_port}";

    my $sock = IO::Socket::INET->new(
        PeerAddr => $server,
        Proto => "tcp",
    );
    die "Failed to connect ${server}: $!" unless defined $sock;

    my $req = build_get_request($server_addr, $server_port, $path);
    print "[Request]\n" . $req;
    print $sock $req;

    my ($status, $headers, $body) = read_http_response($sock);
    print "[Response]\n" . $status . "\n";
    use Data::Dumper;
    print Dumper($headers);
}

sub read_http_response {
    my ($sock, $no_body) = @_;

    my $status_line = readline($sock);
    die "Unexpected EOF while reading HTTP status" unless defined $status_line;
    $status_line =~ s/\r?\n$//;

    my @headers;
    my $content_length;
    while (1) {
        my $header_line = readline($sock);
        die "Unexpected EOF while reading HTTP header" unless defined $header_line;
        $header_line =~ s/\r?\n//;
        last if $header_line eq "";

        my ($name, $value) = split(/\s*:\s*/, $header_line, 2);
        $value = "" unless defined $value;
        push(@headers, [$name, $value]);

        if (lc $name eq "content-length") {
            $content_length = $value;
        }
    }

    my $body = "";
    if (defined $content_length) {
        if ($content_length > 0) {
            if ($no_body) {
                read($sock, undef, $content_length);
            } else {
                read($sock, $body, $content_length);
            }
        }
    } else {
        if (defined $no_body) {
            read_all($sock);
        } else {
            $body = read_all($sock);
        }
    }

    return ($status_line, \@headers, $body);
}

sub build_get_request {
    my ($addr, $port, $path, $keepalive) = @_;
    my @headers;

    if ($port == 80) {
        push(@headers, ["Host", $addr]);
    } else {
        push(@headers, ["Host", "${addr}:${port}"]);
    }

    if (defined $keepalive && $keepalive) {
        push(@headers, ["Connection", "keep-alive"]);
        push(@headers, ["Content-Length", 0]);
    } else {
        push(@headers, ["Connection", "close"]);
    }

    return build_http_request("GET", $path, \@headers, "");
}

sub build_http_request {
    my ($method, $path, $headers, $body) = @_;
    my $req = "${method} ${path} HTTP/1.1\r\n";
    for my $header (@$headers) {
        my ($name, $value) = @$header;
        $req .= "${name}: ${value}\r\n";
    }
    $req .= "\r\n";
    $req .= $body;
    return $req;
}

sub read_all {
    my $handle = shift;
    local $/ = undef;
    return scalar <$handle>;
}

