#!/usr/bin/env perl
# SPDX-License-Identifier: WTFPL
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";
use Esu qw(english_text);
use IO::Socket::INET;
use IO::Select;
my $port = shift // 2323;
my $server = IO::Socket::INET->new(LocalAddr => '127.0.0.1', LocalPort => $port, Listen => 5, ReuseAddr => 1) or die $!;
my $select = IO::Select->new($server);
my %sessions;
$| = 1;
print "Telnet: 127.0.0.1 $port (Space: next page, q: quit)\n";
sub show_page {
    my ($s) = @_;
    my $sock = $s->{socket};
    my @page = splice @{$s->{lines}}, 0, 20;
    print {$sock} join("\r\n", @page), "\r\n";
    print {$sock} @{$s->{lines}} ? '--More-- (Space/Enter: next, q: quit)' : '[End - q: quit]';
}
while (1) {
    for my $socket ($select->can_read(1)) {
        if ($socket == $server) {
            my $client = $server->accept or next;
            binmode $client;
            $client->autoflush(1);
            my @lines = split /\r\n/, english_text($FindBin::Bin);
            my $s = {socket => $client, lines => \@lines, state => 'data', skip_lf => 0};
            $sessions{fileno $client} = $s;
            $select->add($client);
            show_page($s);
            next;
        }
        my $id = fileno $socket;
        my $s = $sessions{$id};
        my $count = sysread($socket, my $buffer, 4096);
        my $quit = !defined($count) || !$count;
        for my $byte (unpack 'C*', $buffer // '') {
            last if $quit;
            my $state = $s->{state};
            if ($state eq 'iac') {
                if ($byte == 251 || $byte == 253 || $byte == 252 || $byte == 254) {
                    $s->{command} = $byte; $s->{state} = 'option';
                } elsif ($byte == 250) { $s->{state} = 'sub'; }
                else { $s->{state} = 'data'; }
            } elsif ($state eq 'option') {
                # Refuse unsupported options; do not acknowledge refusals.
                print {$socket} pack('CCC', 255, $s->{command} == 253 ? 252 : 254, $byte)
                    if $s->{command} == 253 || $s->{command} == 251;
                $s->{state} = 'data';
            } elsif ($state eq 'sub') {
                $s->{state} = 'sub_iac' if $byte == 255;
            } elsif ($state eq 'sub_iac') {
                $s->{state} = $byte == 240 ? 'data' : 'sub';
            } elsif ($byte == 255) { $s->{state} = 'iac'; }
            elsif ($byte == 113 || $byte == 81) { $quit = 1; }
            elsif ($byte == 10 && $s->{skip_lf}) { $s->{skip_lf} = 0; }
            elsif ($byte == 32 || $byte == 13 || $byte == 10) {
                $s->{skip_lf} = $byte == 13;
                print {$socket} "\r\n";
                show_page($s);
            }
        }
        if ($quit) { $select->remove($socket); close $socket; delete $sessions{$id}; }
    }
}
