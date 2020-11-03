# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  body       :text(65535)      not null
#  images     :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

# imagesのFactoryの書き方については公式GitHubを参照した（以下のとおり）
# https://github.com/carrierwaveuploader/carrierwave/wiki/How-to:-Use-test-factories

FactoryBot.define do
  factory :post do
    sequence(:body) { |n| "This is the description of pictures! (Post#{n})" }
    images { [Rack::Test::UploadedFile.new(Rails.root.join('spec/support/sample1.png'), 'image/png'),
              Rack::Test::UploadedFile.new(Rails.root.join('spec/support/sample2.png'), 'image/png'),
              Rack::Test::UploadedFile.new(Rails.root.join('spec/support/sample3.png'), 'image/png')] }
    user
  end
end
