# == Schema Information
#
# Table name: users
#
#  id                      :bigint           not null, primary key
#  avatar                  :string(255)
#  crypted_password        :string(255)
#  email                   :string(255)      not null
#  notification_on_comment :boolean          default(TRUE)
#  notification_on_follow  :boolean          default(TRUE)
#  notification_on_like    :boolean          default(TRUE)
#  salt                    :string(255)
#  username                :string(255)      not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_users_on_email     (email) UNIQUE
#  index_users_on_username  (username) UNIQUE
#
FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "mike miketa" << n.to_s }
    email { "#{username.gsub(/[[:space:]]/, '')}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    notification_on_comment { false }
    notification_on_like { false }
    notification_on_follow { false }
  end
end
