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
          dom = parse_html(@target_url)
          dom.xpath(@news_xpath).each do |node|
            data_hash = scrape_news_data(node)
            f.write(JSON.dump(data_hash) + ",\n")
          end
          @target_url = get_next_url(dom)
          break if @target_url.nil?
          sleep 1
        end
        f.write(']')
      end
    end

    def parse_html(url)
      charset = nil
      html = open(url) do |f|
        charset = f.charset
        f.read
      end
      Nokogiri::HTML.parse(html, nil, charset)
    end

    def scrape_news_data(node)
      date = node.xpath('dt').inner_text
      label = node['class']
      url = node.xpath('dd/a')[0][:href]
      description =  node.xpath('dd').inner_text
      {date: date, label: label, url: url, description: description}
    end

    def get_next_url(dom)
      return nil if dom.xpath(@next_url_xpath).empty?
      dom.xpath(@next_url_xpath)[0].attribute('href').value
    end
  end
end

Scraping.run
