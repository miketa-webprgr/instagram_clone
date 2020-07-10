# frozen_string_literal: true

Kaminari.configure do |config|
  # ページあたり表示数を10件とする
  # ryotaさんのブログが参考になった
  # [【Rails】kaminariを使用してページネーション機能を実装 \- Qiita](https://qiita.com/ryota21/items/29fa282745afb1474059#設定ファイルの説明)

  config.default_per_page = 15
  # config.max_per_page = nil
  # config.window = 4
  # config.outer_window = 0
  # config.left = 0
  # config.right = 0
  # config.page_method_name = :page
  # config.param_name = :page
  # config.max_pages = nil
  # config.params_on_first_page = false
end
