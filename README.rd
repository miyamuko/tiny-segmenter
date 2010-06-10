= tiny-segmenter - xyzzy Lisp だけで実装されたコンパクトな分かち書きソフトウェア

  * Author: みやむこ かつゆき ((<URL:mailto:miyamuko@gmail.com>))
  * Home URL: ((<URL:http://miyamuko.s56.xrea.com/xyzzy/tiny-segmenter/intro.htm>))
  * Version: 1.1.0


== SYNOPSIS

  (require "tiny-segmenter")

  (ts:segment "私の名前は中野です。")
  ;;=> ("私" "の" "名前" "は" "中野" "です" "。")

  (setf *str* "tiny-segmenter は
  「TinySegmenter: Javascript だけで実装されたコンパクトな分かち書きソフトウェア」を
  xyzzy lisp に移植したものです。")

  (setf *segmenter* (ts:make-segmenter *str*))

  (ts:segmenter-segment-next *segmenter*)
  ;;=> "tiny"

  (ts:segmenter-segment-next *segmenter*)
  ;;=> "-segmenter"

  (ts:segmenter-segment-partial *segmenter* 3)
  ;;=> (" " "は" "
  ;;   「")

  (ts:segmenter-segment-partial *segmenter* 5)
  ;;=> ("TinySegmenter" ": " "Javascript" " " "だけ")

  (ts:segmenter-segment-partial *segmenter* 10)
  ;;=> ("で" "実装" "さ" "れ" "た" "コンパクト" "な" "分かち" "書き" "ソフトウェア")

  (ts:segmenter-segment-all *segmenter*)
  ;;=> ("」" "を" "
  ;;   xyzzy" " lisp" " " "に" "移植し" "た" "もの" "です" "。")


== DESCRIPTION

tiny-segmenter は
((<"TinySegmenter: Javascript だけで実装されたコンパクトな分かち書きソフトウェア"|URL:http://chasen.org/~taku/software/TinySegmenter/>))
を xyzzy lisp に移植したものです。

上記 URL によれば以下のような特徴があります。

  * 日本語の新聞記事であれば文字単位で 95% 程度の精度で分かち書きが行える
  * 分かち書きの単位は MeCab + ipadic と互換
  * 辞書を使っていません (機械学習のみ)。
    xyzzy lisp のみで分かち書きを行えます。


== INSTALL

tiny-segmenter はライブラリです。

=== NetInstaller でインストール

(1) ((<NetInstaller|URL:http://www7a.biglobe.ne.jp/~hat/xyzzy/ni.html>))
    で tiny-segmenter をインストールします。

=== NetInstaller を使わずにインストール

(1) アーカイブをダウンロードします。

    ((<URL:http://miyamuko.s56.xrea.com/xyzzy/archives/tiny-segmenter.zip>))

(2) アーカイブを展開して、$XYZZY/site-lisp 配下にファイルをコピーします。


== MODULE

=== DEPENDS

依存モジュールはありません。


=== PACKAGE

tiny-segmenter は以下のパッケージを利用しています。

  * tiny-segmenter

    nickname は ts です。


=== EXPORT

tiny-segmenter は以下のシンボルを export しています。

  * tiny-segmenter:segment
  * tiny-segmenter:make-segmenter
  * tiny-segmenter:segmenter-segment-all
  * tiny-segmenter:segmenter-segment-partial
  * tiny-segmenter:segmenter-segment-next


=== CONDITION

なし。

=== VARIABLE

なし。

=== COMMAND

なし。

=== FUNCTION

--- tiny-segmenter:segment INPUT

    INPUT で指定されたオブジェクトを分かち書きしてリストで返します。

      ; string
      (ts:segment "xyzzy の読み方が分かりません。")
      ;;=> ("xyzzy" " " "の" "読み方" "が" "分かり" "ませ" "ん" "。")

      ; stream
      (with-input-from-string (s "xyzzy の読み方が分かりません。")
        (ts:segment s))

      ; buffer
      (ts:segment (find-buffer "*scratch*"))

    * INPUT には以下のオブジェクトを指定できます。
      * 文字列
      * ストリーム
      * バッファ
    * nil または空文字列を指定した場合は nil を返します。

--- tiny-segmenter:make-segmenter INPUT

    INPUT で指定されたオブジェクトを分かち書きする SEGMENTER オブジェクトを返します。

    SEGMENTER オブジェクトは INPUT を保持し、以下の関数が呼ばれるたびに
    分かち書き処理を進めます。

    * ((<segmenter-segment-next|tiny-segmenter:segmenter-segment-next SEGMENTER>))
    * ((<segmenter-segment-partial|tiny-segmenter:segmenter-segment-partial SEGMENTER N>))
    * ((<segmenter-segment-all|tiny-segmenter:segmenter-segment-all SEGMENTER>))

    すべての INPUT を処理した後は、これらの関数は nil を返します。

    * INPUT には以下のオブジェクトを指定できます。
      * 文字列
      * ストリーム
      * バッファ
    * nil または空文字列を指定した場合は nil を返します。

    ※注意※

    現在のバージョンでは SEGMENTER オブジェクトはクロージャとして実装されていますが、
    将来のバージョンで変更する可能性があります。
    直接 funcall するのは避けてください。

--- tiny-segmenter:segmenter-segment-next SEGMENTER

    SEGMENTER オブジェクトが保持する残りの INPUT を分かち書きして
    次の単語を取得します。

      (setf *segmenter* (ts:make-segmenter "xyzzy の読み方が分かりません。"))

      (ts:segmenter-segment-next *segmenter*)
      ;;=> "xyzzy"

      (ts:segmenter-segment-next *segmenter*)
      ;;=> " "

      (ts:segmenter-segment-next *segmenter*)
      ;;=> "の"

--- tiny-segmenter:segmenter-segment-partial SEGMENTER N

    SEGMENTER オブジェクトが保持する残りの INPUT を分かち書きして
    N 個の単語のリストを取得します。

      (setf *segmenter* (ts:make-segmenter "xyzzy の読み方が分かりません。"))
      
      (ts:segmenter-segment-partial *segmenter* 7)
      ;;=> ("xyzzy" " " "の" "読み方" "が" "分かり" "ませ")
      
      (ts:segmenter-segment-partial *segmenter* 7)
      ;;=> ("ん" "。")
      
      (ts:segmenter-segment-partial *segmenter* 7)
      ;;=> nil

--- tiny-segmenter:segmenter-segment-all SEGMENTER

    SEGMENTER オブジェクトが保持する残りの INPUT すべて分かち書きして
    単語のリストを取得します。

      (setf *segmenter* (ts:make-segmenter "xyzzy の読み方が分かりません。"))

      (ts:segmenter-segment-next *segmenter*)
      ;;=> "xyzzy"

      (ts:segmenter-segment-all *segmenter*)
      ;;=> (" " "の" "読み方" "が" "分かり" "ませ" "ん" "。")

--- tiny-segmenter:tiny-segmenter-version

    本ライブラリのバージョンを返します。
    バージョンは major.minor.teeny という形式です。

    それぞれの番号は必ず 1 桁にするので、以下のように比較することができます

        (if (string<= "1.1.0" (tiny-segmenter:tiny-segmenter-version))
            '(1.1.0 以降で有効な処理)
          '(1.1.0 より前のバージョンでの処理))


== TODO

* make-segmenter
  * 最初の初期化処理を遅延
  * stream から読み込みながら分かち書きを進める


== KNOWN BUGS

なし。


== SEE ALSO

  : TinySegmenter: Javascript だけで実装されたコンパクトな分かち書きソフトウェア
      ((<URL:http://chasen.org/~taku/software/TinySegmenter/>))

  : Text::TinySegmenter - Super compact Japanese tokenizer - search.cpan.org
      ((<URL:http://search.cpan.org/dist/Text-TinySegmenter/>))

  : TinySegmenterをRubyに移植してみた[Ruby] - d.hatena.zeg.la
      ((<URL:http://d.hatena.ne.jp/zegenvs/20080212/p1>))

  : TinySegmenterをRubyに移植 - llameradaの日記
      ((<URL:http://d.hatena.ne.jp/llamerada/20080224/1203818061>))


== COPYRIGHT

tiny-segmenter は工藤拓氏によって開発された JavaScript 版の TinySegmenter を
xyzzy lisp に移植したものです。

tiny-segmenter は修正 BSD ライセンスに従って本ソフトウェアを使用、再配布することができます。

  tiny-segmenter -- Super compact Japanese tokenizer
  
  (c) 2008 Taku Kudo <taku@chasen.org>
  (c) 2008 MIYAMUKO Katsuyuki  <miyamuko@gmail.com>
  
  tiny-segmenter is freely distributable under the terms of a new BSD licence.
  For details, see http://chasen.org/~taku/software/TinySegmenter/LICENCE.txt


== NEWS

<<<NEWS.rd
