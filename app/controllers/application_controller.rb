class ApplicationController < ActionController::Base
  # notice, alert 以外のflashメッセージを使いたい場合、指定する必要がある
  add_flash_types :success, :info, :warning, :danger
end
