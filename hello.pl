#!/usr/bin/env perl
use strict;
use warnings;
use IO::Socket::INET;

my $server = IO::Socket::INET->new(
    LocalAddr => '127.0.0.1',
    LocalPort => 8080,
    Listen    => 5,
    ReuseAddr => 1,
) or die "Cannot listen on port 8080: $!\n";

while (my $client = $server->accept) {
    binmode $client;
    while (my $line = <$client>) {
        last if $line =~ /^\r?\n$/;
    }
    my $body = "Hello World\n";
    print {$client} "HTTP/1.0 200 OK\r\n",
        "Content-Type: text/plain; charset=utf-8\r\n",
        "Content-Length: ", length($body), "\r\n",
        "Connection: close\r\n\r\n", $body;
    close $client;
}
