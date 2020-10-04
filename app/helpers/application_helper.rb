module ApplicationHelper
  def default_meta_tags
    {
      # サイト名
      site: Settings.meta.site,
      # trueの場合、ページのタイトル名 → サイト名 という表記の仕方になる
      reverse: true,
      # ページのタイトル名
      title: Settings.meta.title,
      # ページの概要（検索サイトなどに表示される）
      description: Settings.meta.description,
      # 検索ワード（ただ、SEO的に意味がないらしい）
      keywords: Settings.meta.keywords,
      # 似たようなサイトがある場合、これを使ってまとめる
      canonical: request.original_url,
      # FacebookやTwitterでいい感じにリンクを表示させるための設定
      og: {
        title: :full_title,
        type: Settings.meta.og.type,
        url: request.original_url,
        image: image_url(Settings.meta.og.image_path),
        site_name: :site,
        description: :description,
        locale: 'ja_JP'
      },
      # Twitterでリンクを表示させる場合のカードの種類を設定
      twitter: {
        card: 'summary_large_image',
        image: {
          _: Settings.meta.og.image_path,
        }
      },
      # アイコンを設定してみました（みけた独自）。
      # 以下のサイトを利用して、勝手にやってみました。スマホの場合でもいい感じのアイコンを作ってくれます。
      # 定数管理が面倒だったので、今回は直書きにしちゃいました。
      # https://www.favicon-generator.org/
      icon: [
        { href: '/favicon/apple-icon-57x57.png', sizes: '57x57', type: 'image/png' },
        { href: '/favicon/apple-icon-60x60.png', sizes: '60x60', type: 'image/png' },
        { href: '/favicon/apple-icon-72x72.png', sizes: '72x72', type: 'image/png' },
        { href: '/favicon/apple-icon-76x76.png', sizes: '76x76', type: 'image/png' },
        { href: '/favicon/apple-icon-114x114.png', sizes: '114x114', type: 'image/png' },
        { href: '/favicon/apple-icon-120x120.png', sizes: '120x120', type: 'image/png' },
        { href: '/favicon/apple-icon-144x144.png', sizes: '144x144', type: 'image/png' },
        { href: '/favicon/apple-icon-152x152.png', sizes: '152x152', type: 'image/png' },
        { href: '/favicon/apple-icon-180x180.png', sizes: '180x180', type: 'image/png' },
        { href: '/favicon/android-icon-192x192.png', sizes: '192x192', type: 'image/png' },
        { href: '/favicon/favicon-32x32.png', sizes: '32x32', type: 'image/png' },
        { href: '/favicon/favicon-96x96.png', sizes: '96x96', type: 'image/png' },
        { href: '/favicon/favicon-16x16.png', sizes: '16x16', type: 'image/png' },
      ],
      # その他、favicon-generatorに勧められた内容を設定した（主にWindows用）
      # ハイフンを含むハッシュの場合、クオートで囲まないと例外処理となってしまう
      'msapplication-TileColor': '#ffffff',
      'application-TileImage': '/favicon/ms-icon-144x144.png',
      'theme-color': '#ffffff',
    }
  end
end
