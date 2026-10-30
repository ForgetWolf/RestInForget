# Licensing scope

The original program code, build scripts and HTML templates of esu! are licensed
under WTFPL version 2; see `LICENSE`.

Original prose in `zh-cn.md`, `en-us.md`, and the README, including article text
reproduced in generated HTML, plain text and Telnet output, is licensed under
Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International
(CC BY-NC-SA 4.0). See `CONTENT_LICENSE.md` and `LICENSE-CONTENT.txt`.

Neither grant relicenses third-party code or third-party material.
The Sam Hocevar copyright in `LICENSE` identifies the license document's author,
not the author of this project.

## Bundled: Text::Markdown 1.000031

Source: https://metacpan.org/release/BOBTFISH/Text-Markdown-1.000031

`lib/Text/Markdown.pm` retains its original BSD-3-Clause-form terms and copyright
notices, rather than WTFPL. Preserve the notices and disclaimer when redistributing.
The distribution's license text is also retained in
`lib/Text/Markdown-LICENSE.txt`.

Copyright holders identified in the module:

- Original code: (c) 2003-2004 John Gruber.
- MultiMarkdown changes: (c) 2005-2006 Fletcher T. Penney.
- Text::MultiMarkdown changes: (c) 2006-2009 Darren Kulp and Tomas Doran.

## External runtime dependencies (not bundled)

`HTML::TreeBuilder` (HTML-Tree), `HTTP::Daemon`, and `HTTP::Response`
(HTTP-Message) declare licensing under the same terms as Perl itself.
Perl 5 offers the Artistic License or GPL version 1 or later as alternatives:
https://dev.perl.org/licenses/

The Artistic alternative can be used for these dependencies. Their own terms
and those of their dependencies remain applicable; the project's WTFPL grant
does not replace them. Perl and its core modules are supplied by the user's
Perl installation. This project does not distribute that installation.

Static HTML/text hosting does not require installing or distributing the Perl
runtime dependencies. No terminal.css, termcss, or xterm.js code is included.
