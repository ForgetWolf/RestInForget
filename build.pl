#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";
use Esu qw(page english_text);
use File::Path qw(make_path);
use File::Copy qw(copy);
make_path("$FindBin::Bin/dist");
for my $notice ('LICENSE', 'THIRD_PARTY_NOTICES.md') {
    copy("$FindBin::Bin/$notice", "$FindBin::Bin/dist/$notice") or die "Copy $notice: $!";
}
open my $marker, '>', "$FindBin::Bin/dist/.nojekyll" or die $!;
close $marker;
for my $entry (['index.html', 'zh'], ['en.html', 'en']) {
    open my $out, '>:encoding(UTF-8)', "$FindBin::Bin/dist/$entry->[0]" or die $!;
    print {$out} page($FindBin::Bin, $entry->[1], 0);
    close $out or die $!;
}
open my $txt, '>:raw', "$FindBin::Bin/dist/en.txt" or die $!;
print {$txt} english_text($FindBin::Bin);
close $txt or die $!;
print "Generated dist/index.html, dist/en.html, dist/en.txt\n";
