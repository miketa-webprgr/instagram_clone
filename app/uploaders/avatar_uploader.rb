class AvatarUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick

  # リサイズなどを行うにあたって、公式も推奨しているMiniMagickを採用
  # 使う場合はImageMagickをHomebrewなどでインストールする必要がある
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file

  # 画像の保存先の設定
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # ファイルがアップロードされていない場合、デフォルトの画像を使用するよう設定できる。
  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    'profile-placeholder.png'
  end

  # アップロードする過程でファイルをリサイズしてくれる
  # [CarrierWave\+MiniMagickで使う、画像リサイズのメソッド \- Qiita](https://qiita.com/wann/items/c6d4c3f17b97bb33936f)
  # Process files as they are uploaded:
  # process scale: [200, 300]
  # 縦と横の幅を最大400pxとする。なお、他にもresize_to_sizeなどがある。
  process resize_to_limit: [400, 400]

  # サムネ用のファイルもアップロードする場合、設定を行う
  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # アップロードできるファイルの拡張子を制限する
  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
end
