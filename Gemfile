# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

ruby '2.6.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.4.4', '< 0.6.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# 今回導入したgem
gem 'jquery-rails'
gem 'popper_js'
gem 'sorcery'
gem 'slim-rails'
gem 'redis-rails'
gem 'rails-i18n'
gem 'annotate'
gem 'font-awesome-sass'
gem 'carrierwave'
gem 'faker'
gem 'kaminari'
gem 'config'
gem 'sidekiq'
gem 'sinatra'
gem 'meta-tags'

# NGワードの投稿を禁止するために導入。設定方法は以下を参照。
# https://github.com/joshbuddy/swearjar
gem 'swearjar'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  # bin/rspecを使うために導入した
  gem 'spring-commands-rspec'
  # RSpecのデバッグにも使用するため
  gem 'pry-byebug'
  gem 'pry-rails'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  # 今回導入するgem
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'letter_opener_web'
end
