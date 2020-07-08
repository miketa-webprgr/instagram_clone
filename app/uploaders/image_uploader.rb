class ImageUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # リサイズなどを行うにあたって、公式も推奨しているMiniMagickを採用
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file

  # fogはS3などのクラウドに画像を保存する場合に必要
  # storage :fog

  # 画像の保存先の設定
  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # ファイルがアップロードされていない場合、デフォルトのアップロード先URLを設定する
  # ・・・何に使うんだろう？
  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # これを設定すると、アップロードする過程でファイルをリサイズしてくれるらしい
  # つまり、carrierwaveにおいては、ファイル自体はデフォルトのサイズでアップロードするが、表示する段階においてリサイズしている
  # それだとサイズの大きいファイルがサーバーにアップロードされて困る！っていう人はここで設定しろ、ということだと思う
  # https://github.com/carrierwaveuploader/carrierwave#adding-versions
  # 今回は不要なので、特に設定されていない
  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # サムネ用の小さいサイズの画像もアップロードしたい場合に使用する
  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # ホワイトリスト。拡張子でアップロードできるファイルを制限している
  # モデルでバリデーションをかけるのも忘れないように！
  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w[jpg jpeg gif png]
  end

  # ファイル名の設定。モデルidを名前に使うなと書いてある。。。
  # 真面目なので、ちゃんとuploader/store.rbを読んでみた！！！
  # https://github.com/carrierwaveuploader/carrierwave/blob/master/lib/carrierwave/uploader/store.rb
  # コードの解読はスルーしたが、DBに保存する時に、record id will be nil と書いてあった
  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
end
