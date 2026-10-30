#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";
use Esu qw(page);
use Encode qw(encode);
my $lang = 'zh-cn';
if (($ENV{QUERY_STRING} // '') =~ /(?:^|&)lang=([^&]*)/i) {
    # 旧参数兼容已停用；仅 en-us 选择英文，其余值使用默认中文。
    # $lang = lc($1) =~ /\Aen(?:-us)?\z/ ? 'en-us' : 'zh-cn';
    $lang = lc($1) eq 'en-us' ? 'en-us' : 'zh-cn';
}
binmode STDOUT, ':raw';
my $html = encode('UTF-8', page($FindBin::Bin, $lang, 1));
print "Content-Type: text/html; charset=UTF-8\r\n\r\n", $html;
