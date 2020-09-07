class NgWordsValidator < ActiveModel::Validator
  def validate(record)
    # NGワードをここで読み込む
    ng_words = Swearjar.new('config/locales/my_swears.yml')
    # NGワードを含んでいる場合はerrorを返す
    record.errors.add(:body, 'にはNGワードが含まれています。綺麗な言葉を使いましょう。') if ng_words.profane?(record.body)
  end
end
