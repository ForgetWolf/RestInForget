#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";
use Esu qw(page);
use Encode qw(encode);
my $lang = ($ENV{QUERY_STRING} // '') =~ /(?:^|&)lang=en(?:&|$)/ ? 'en' : 'zh';
binmode STDOUT, ':raw';
my $html = encode('UTF-8', page($FindBin::Bin, $lang, 1));
print "Content-Type: text/html; charset=UTF-8\r\n\r\n", $html;
