package Esu;
use strict;
use warnings;
use utf8;
use Text::Markdown qw(markdown);
use HTML::TreeBuilder;
use Text::Wrap;
use Exporter 'import';
our @EXPORT_OK = qw(page english_text);

sub source {
    my ($root, $lang) = @_;
    my $name = $lang eq 'en' ? 'esuen.md' : 'esu.md';
    open my $fh, '<:encoding(UTF-8)', "$root/$name" or die "Read $name: $!";
    local $/;
    my $md = <$fh>;
    # HTML comments are retained in the source files, omitted from served content.
    $md =~ s/<!--.*?-->//sg;
    # Layout wrappers are unnecessary with browser defaults; removing them also
    # allows Markdown nested inside divs to be parsed consistently.
    $md =~ s{</?div\b[^>]*>}{}gi;
    # The bundled original Markdown parser uses word boundaries for emphasis;
    # explicitly preserve this document's bold spans adjacent to Chinese text.
    $md =~ s{\*\*([^\n]+?)\*\*}{<strong>$1</strong>}g;
    return $md;
}

sub article {
    my ($root, $lang) = @_;
    my $md = source($root, $lang);
    # Original Markdown has no pipe tables. Convert these before the main pass.
    $md =~ s{(^\|[^\n]+\n\|[ \t:|\-]+\n(?:\|[^\n]+(?:\n|\z))*)}{table($1)}gme;
    my $html = markdown($md);
    # A list item's introductory paragraph before a nested list should align
    # with its siblings, without the browser's extra paragraph top margin.
    $html =~ s{(<li>)<p>(.*?)</p>(?=\s*<(?:ul|ol)\b)}{$1$2}gs;
    return $html;
}

sub table {
    my ($block) = @_;
    my @rows = split /\n/, $block;
    my $html = "\n<table border=\"1\" cellpadding=\"8\" cellspacing=\"0\" bordercolor=\"#385c42\">\n";
    for my $i (0 .. $#rows) {
        next if $i == 1;
        my $row = $rows[$i];
        $row =~ s/^\|//;
        $row =~ s/\|\s*$//;
        my $tag = $i == 0 ? 'th' : 'td';
        $html .= '<tr>';
        for my $cell (split /\|/, $row, -1) {
            my $value = markdown($cell);
            $value =~ s{^<p>|</p>\s*$}{}g;
            $html .= "<$tag>$value</$tag>";
        }
        $html .= "</tr>\n";
    }
    return "$html</table>\n\n";
}

sub page {
    my ($root, $lang, $cgi) = @_;
    my $zh = $cgi ? 'index.pl' : 'index.html';
    my $en = $cgi ? 'index.pl?lang=en' : 'en.html';
    my $body = article($root, $lang);
    $body =~ s{<hr\b[^>]*>}{<hr color="#385c42" size="1" noshade>}gi;
    my @toc;
    my $n = 0;
    $body =~ s{<h([1-6])>(.*?)</h\1>}{
        my ($level, $text) = ($1, $2);
        my $id = 'section-' . ++$n;
        my $number = sprintf '%02d', $n;
        push @toc, qq(<li><a href="#$id">$text</a></li>);
        qq(<h$level id="$id"><font face="monospace" size="4" color="#b4e4b0">[$number] $text</font></h$level>);
    }gse;
    # Deliberately use legacy HTML presentation attributes for this zero-CSS
    # retro edition. Keep prose outside pre so Chinese and long lines wrap.
    my $edge = '+' . ('-' x 42) . "+\n";
    my $banner = $edge
        . sprintf("| %-40s |\n", 'F O R G E T W O L F  /  A R C H I V E')
        . sprintf("| %-40s |\n", 'PERSONAL LOG                 [ ONLINE ]')
        . $edge;
    my $navigation = $lang eq 'en' ? 'INDEX / OPEN DIRECTORY' : 'INDEX / 展开目录';
    my $back = $lang eq 'en' ? 'BACK TO TOP' : '返回顶部';
    return qq(<!doctype html>\n<html lang="$lang">\n<head>\n<meta charset="utf-8">\n<meta name="viewport" content="width=device-width, initial-scale=1">\n<title>ForgetWolf - Archive</title>\n</head>\n<body id="top" bgcolor="#080d09" text="#95c98b" link="#e0c078" vlink="#a6ad78" alink="#ffffff">\n<table width="90%" align="center" cellpadding="12" cellspacing="0"><tr><td>\n<font face="monospace" size="3">\n<header>\n<pre>$banner</pre>\n<nav>[ <a href="$zh">ZH / 中文</a> ] &nbsp; [ <a href="$en">EN / English</a> ] &nbsp; [ <a href="#directory">INDEX</a> ]</nav>\n<hr color="#385c42" size="1">\n</header>\n<details id="directory"><summary>$navigation</summary><ol>) . join('', @toc) . qq(</ol></details>\n<hr color="#385c42" size="1">\n<main>\n$body</main>\n<p>[ <a href="#top">^ $back</a> ]</p>\n</font>\n</td></tr></table>\n</body>\n</html>\n);
}

sub english_text {
    my ($root) = @_;
    my $tree = HTML::TreeBuilder->new;
    $tree->parse_content(article($root, 'en'));
    my $walk;
    $walk = sub {
        my ($node) = @_;
        return $node unless ref $node;
        my $tag = $node->tag;
        return '' if $tag =~ /^(?:script|style|~comment)$/;
        return "\n" if $tag eq 'br';
        my $s = join '', map { $walk->($_) } $node->content_list;
        return "$s: " if $tag =~ /^(?:th|td)$/;
        return "\n- $s\n" if $tag eq 'li';
        return "\n$s\n" if $tag =~ /^(?:p|h[1-6]|tr|blockquote|ul|ol|hr)$/;
        return $s;
    };
    my $text = $walk->($tree);
    $tree->delete;
    $text =~ s/[‘’]/'/g;
    $text =~ s/[“”]/"/g;
    $text =~ s/[–—]/-/g;
    $text =~ s/\x{a0}/ /g;
    $text =~ s/…/.../g;
    $text =~ s/·/*/g;
    $text =~ s/[^\x09\x0a\x0d\x20-\x7e]/?/g;
    $text =~ s/\n[ \t]*\n(?:[ \t]*\n)+/\n\n/g;
    local $Text::Wrap::columns = 79;
    $text = join "\n", map { Text::Wrap::wrap('', '', $_) } split /\n/, $text;
    $text =~ s/\r?\n/\r\n/g;
    return "$text\r\n";
}
1;
