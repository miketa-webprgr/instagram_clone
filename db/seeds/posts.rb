puts 'posts のシードを投稿します ...'

# rails db:seed を実行すると、Userのシードが10個作成される
# あまりにもUserがいると、このコマンドを実行した際に膨大な投稿がなされてしまうので、User30人までにしか投稿をしないよう制限を設けた
# remote_images_urls のメソッドはここに書いてあった
# https://github.com/carrierwaveuploader/carrierwave/blob/master/lib/carrierwave/mount.rb

User.limit(30).each do |user|
  post = user.posts.create(body: "#{Faker::Sports::Football.team} is the best team!!!", remote_images_urls: %w[https://picsum.photos/350/?random https://picsum.photos/350/?random])
  puts "post#{post.id} を作成した!"
end
