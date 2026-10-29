#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use HTTP::Daemon;
use HTTP::Response;
my $port = shift // 8081;
my $server = HTTP::Daemon->new(LocalAddr => '127.0.0.1', LocalPort => $port, ReuseAddr => 1) or die $!;
$| = 1;
print "Static: http://127.0.0.1:$port/\nCGI: http://127.0.0.1:$port/index.pl\n";
while (my $client = $server->accept) {
    $client->timeout(5);
    if (my $request = $client->get_request) {
        my $path = $request->uri->path;
        my ($body, $type);
        if ($request->method ne 'GET' && $request->method ne 'HEAD') {
            $client->send_error(405);
        } elsif ($path eq '/index.pl') {
            local $ENV{QUERY_STRING} = $request->uri->query // '';
            local $ENV{REQUEST_METHOD} = $request->method;
            open my $cgi, '-|', $^X, "$FindBin::Bin/index.pl" or die $!;
            binmode $cgi;
            { local $/; $body = <$cgi>; }
            my $ok = close $cgi;
            if (!$ok) { $client->send_error(500); }
            else {
                $body =~ s/\A.*?\r\n\r\n//s;
                my $res = HTTP::Response->new(200);
                $res->header('Content-Type' => 'text/html; charset=UTF-8');
                $res->content($body);
                $client->send_response($res);
            }
        } else {
            my %files = ('/' => 'index.html', '/index.html' => 'index.html', '/en.html' => 'en.html', '/en.txt' => 'en.txt');
            if (exists $files{$path}) {
                $client->send_file_response("$FindBin::Bin/dist/$files{$path}");
            } else { $client->send_error(404); }
        }
    }
    $client->close;
}
