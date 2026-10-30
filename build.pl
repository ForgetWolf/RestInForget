#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";
use Esu qw(page english_text);
use File::Path qw(make_path);
use File::Copy qw(copy move);
make_path("$FindBin::Bin/dist");
# 旧产物仅移入本地备份，不删除，也不继续随 dist 发布。
for my $old ('en.html', 'en.txt') {
    next unless -f "$FindBin::Bin/dist/$old";
    make_path("$FindBin::Bin/.local/legacy");
    move("$FindBin::Bin/dist/$old", "$FindBin::Bin/.local/legacy/$old")
        or die "Archive legacy file $old: $!";
}
for my $notice ('LICENSE', 'THIRD_PARTY_NOTICES.md') {
    copy("$FindBin::Bin/$notice", "$FindBin::Bin/dist/$notice") or die "Copy $notice: $!";
}
open my $marker, '>', "$FindBin::Bin/dist/.nojekyll" or die $!;
close $marker;
for my $entry (['index.html', 'zh-cn'], ['english.html', 'en-us']) {
    open my $out, '>:encoding(UTF-8)', "$FindBin::Bin/dist/$entry->[0]" or die $!;
    print {$out} page($FindBin::Bin, $entry->[1], 0);
    close $out or die $!;
}
open my $txt, '>:raw', "$FindBin::Bin/dist/english.txt" or die $!;
print {$txt} english_text($FindBin::Bin);
close $txt or die $!;
# 旧地址兼容已停用，保留实现供参考。
# copy("$FindBin::Bin/dist/english.txt", "$FindBin::Bin/dist/en.txt")
#     or die "Copy legacy English text: $!";
# open my $legacy, '>:encoding(UTF-8)', "$FindBin::Bin/dist/en.html" or die $!;
# print {$legacy} qq(<!doctype html>\n<html lang="en-us">\n<head>\n<meta charset="utf-8">\n<title>ForgetWolf - Archive</title>\n<meta http-equiv="refresh" content="0; url=english.html">\n</head>\n<body>\n<p>[ <a href="english.html">EN / English</a> ]</p>\n</body>\n</html>\n);
# close $legacy or die $!;
print "Generated dist/index.html, dist/english.html, dist/english.txt\n";
