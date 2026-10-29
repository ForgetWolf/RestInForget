# esu!

Perl 生成的复古文字站，提供静态 HTML、Perl CGI 和英文 Telnet 阅读器。零 CSS / JS。

编辑 `esu.md` / `esuen.md`，然后运行：

```sh
perl build.pl
perl preview.pl
```

打开 [静态版](http://127.0.0.1:8081/) 或 [CGI 版](http://127.0.0.1:8081/index.pl)。

- **静态部署**：发布 `dist/` 内的文件到 GitHub Pages / Cloudflare Pages；修改文章后重新生成。
- **CGI 部署**：上传 `index.pl`、`lib/` 和两份 Markdown，配置服务器执行 `.pl`；Unix 上需确认 Perl 路径及可执行权限。
- **Telnet**：运行 `perl telnet.pl`，再连接 `telnet 127.0.0.1 2323`；空格 / 回车翻页，`q` 退出。

依赖 `HTML::TreeBuilder`，本地预览另需 `HTTP::Daemon`；缺少时运行 `cpan HTML::TreeBuilder HTTP::Daemon`。`Text::Markdown` 已附在 `lib/`，保留其许可证。本地服务仅监听本机。

日志与部署 ZIP 不提交，`dist/` 保留在仓库。

自写代码与文章采用 [WTFPL v2](LICENSE)，第三方组件保留原许可证，见 [许可说明](THIRD_PARTY_NOTICES.md)。

> This project was 100% created using True Natural Language Programming (a.k.a. Vibe Coding).
>
> — Codex
