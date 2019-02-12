require 'nokogiri'
require 'open-uri'
require 'json'

class Scraping
  @target_url = 'https://www.gooya.co.jp/news'
  @news_xpath = '//section[@class="news-list__wrap"]/dl'
  @next_url_xpath = '//div[@class="wp-pagenavi"]/a[@class="nextpostslink"]'
  @output_file = 'news_index.json'
  @page_number = 3
  class << self

    def run
      File.open(@output_file, mode = 'w') do |f|
        f.write('[')
        @page_number.times do

          charset = nil
          html = open(@target_url) do |f|
            charset = f.charset
            f.read
          end

          doc = Nokogiri::HTML.parse(html, nil, charset)

          doc.xpath(@news_xpath).each do |node|
            date = node.xpath('dt').inner_text
            label = node['class']
            url = node.xpath('dd/a')[0][:href]
            description =  node.xpath('dd').inner_text
            data = {date: date, label: label, url: url, description: description}
            f.write(JSON.dump(data) + ",\n")
          end

          @target_url = get_next_url(doc)
          break if @target_url.nil?
          sleep 1
        end
        f.write(']')
      end
    end

    def get_next_url(doc)
      return nil if doc.xpath(@next_url_xpath).empty?
      doc.xpath(@next_url_xpath)[0].attribute('href').value
    end
  end
end
