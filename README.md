このリポジトリは、
  Nginx + SiteGuard Lite + ngx_mruby
をCentOS7向けにビルドし、rpmを作成するためのものです。

# 前提

ここでは、さくらのクラウドやさくらのVPSで提供されるSiteGuard Liteを対象としています。
従って、それらの環境のアカウントを持っており、かつそれらのいずれかの環境にてサーバを起動できる必要があります。
また、 Dockerを利用するので、Dockerが使える環境であることも必要です。

# ライセンスに関しての注意

このリポジトリに直接置かれているファイル類については、リポジトリ内に記載しているLICENSEに従います。
一方で、Nginx、SiteGuard Lite, ngx_mrubyについては、それぞれにライセンスが存在するのでそれに従ってください。

# ビルド方法

## Makefileの修正

Makefileの先頭に
```
NGINX_SRC_RPM := nginx-1.13.5-1.el7.ngx.src.rpm
NGX_MRUBY_VER := 1.20.1
SITEGUARD_URL := ＜さくらインターネットより提供されているSiteGuard LiteのダウンロードURLを記載します。＞
SITEGUARD_VER := 3.20-0
```
という定義があります。
ここの設定を適宜変更する必要があります。

すくなくとも `SITEGUARD_URL` の設定は必須です。このURLについては、さくらインターネットより提供されるドキュメントを参照ください。

## ビルド

```
make
```

とすれば、build ディレクトリ配下に RPM が作成されます。

ただし、Nginx の SRPM に含まれる spec ファイルに patch をあてているので、元の spec ファイルが大きく変わるとビルドできない可能性はあります。

以上.
