# Comment, Like, Relationshipモデルで以下のメソッドを使用する
module Notifiable
  extend ActiveSupport::Concern

  # URLヘルパーを使うために導入
  include Rails.application.routes.url_helpers

  included do
    has_one :notification, as: :notifiable, dependent: :destroy
  end

  def call_appropiate_partial
    raise NotImplementedError
  end

  def appropiate_path
    raise NotImplementedError
  end
end
