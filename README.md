## RestInForget
纯Perl/Perl CGI/html，没有css和js的赛博灵堂
兼容telnet（需使用cgi服务，静态不可用）

# 如何使用
ps：这是一个纯自用的东西没考虑过方便其他人，所以如果你恰好感兴趣我建议直接把链接扔给ai

编辑 `zh-cn.md` / `en-us.md`，然后运行：

```sh
perl build.pl
perl preview.pl
```

打开 [静态版](http://127.0.0.1:8081/) 或 [CGI 版](http://127.0.0.1:8081/index.pl)。

英文网页为 `english.html`，ASCII 文本为 `english.txt`，CGI 英文版使用 `index.pl?lang=en-us`。旧地址兼容代码已注释停用；旧生成文件保存在不提交、不发布的 `.local/legacy/`。

- **静态部署**：发布 `dist/` 内的文件到 GitHub Pages / Cloudflare Pages；修改文章后重新生成。
- **CGI 部署**：上传 `index.pl`、`lib/` 和两份 Markdown，配置服务器执行 `.pl`；Unix 上需确认 Perl 路径及可执行权限。
- **Telnet**：运行 `perl telnet.pl`，再连接 `telnet 127.0.0.1 2323`；空格 / 回车翻页，`q` 退出。

依赖 `HTML::TreeBuilder`，本地预览另需 `HTTP::Daemon`；缺少时运行 `cpan HTML::TreeBuilder HTTP::Daemon`。`Text::Markdown` 已附在 `lib/`，保留其许可证。本地服务仅监听本机。

部署ZIP在Release。

自写代码采用 [WTFPL v2](LICENSE)，原创文字采用 [CC BY-NC-SA 4.0](CONTENT_LICENSE.md)。旧版已授予的 WTFPL 权利不撤销；第三方组件保留原许可证，见 [许可说明](THIRD_PARTY_NOTICES.md)。

> This project was 100% created using True Natural Language Programming (a.k.a. Vibe Coding).  —— Codex
