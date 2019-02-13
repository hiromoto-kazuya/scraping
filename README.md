# README

## Description
複数サイトを参考にScrapingクラスを実装しました。
- 'open-uri'のopenメソッドにて対象ページのhtmlを取得。
- そのhtmlを'nokogiri'にてdomへと変換。
- domデータの中から対象となるデータ(date,label,url,description)をxpathで取得。
- 対象データ群を元にjson形式でファイル作成。
- 対象ページに次のページがある場合は、URLを取得して上記手続きを再実行。

## Usage
1. `$ git clone git@github.com:hiromoto-kazuya/scraping.git`
2. '$ cd scraping'
3. '$ bundle install'
4. '$ ruby lib/scraping.rb'実行でjsonファイルが作成される
