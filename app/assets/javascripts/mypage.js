//= require jquery3
//= require popper
//= require rails-ujs
//= require bootstrap-material-design/dist/js/bootstrap-material-design.js

function previewFileWithId(selector) {
  // 【大まかな流れ】
  // アップロード機能を担うinputタグを取得 → そのタグからアップロードしたファイルを取得
  // そのファイルを読み込み、読み込み終わった後に元のアバターと差し替えるイベントを実行する

  // 以下のQiita記事がよくまとまっている
  // [JavaScript FileAPIについて学ぶ \- Qiita](https://qiita.com/kodokunadancer/items/8028d87d8d2bc6c00e69)

  // jQueryにevent.targetというものがあり、イベント発生源である要素を取得する。
  // 今回の場合、`f.file_field :avatar, onchange: 'previewFileWithId(preview)', class: 'form-control', accept: 'image/*'`の部分のinputタグを取得
  const target = this.event.target;

  // filesを使うと、転送中のファイルを取得できる
  const file = target.files[0];

  // ファイルを読み込む
  const reader  = new FileReader();

  // loadendイベントについて記述したコード（これにより、プレビュー画像が非同期通信にて表示される）
  // loadがendした時に発火する
  reader.onloadend = function () {
      selector.src = reader.result;
  }

  // 指定されたファイルオブジェクトを読み込むために使用するメソッド
  // 読込処理が終了すると readyState は DONE に変わり、loadend イベントが生じる。
  // それと同時に result プロパティにはファイルのデータを表す、base64 エンコーディングされた data: URL の文字列が格納される。
  if (file) {
      reader.readAsDataURL(file);

  // ファイルがない場合、`selector.src`を空にする
  // この部分についてコードの意義がよく分からなかったので、TechEssentialsで質問した
  } else {
      selector.src = "";
  }
}
