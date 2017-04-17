class CrawlsController < ApplicationController
  
  require 'mechanize'
  require 'nokogiri'
  require 'open-uri'
  
  def crawl1
    keyword = "npo"
    @elements = google_scraping(keyword)
  end
  
  def crawl2
    search_url = 'https://www.jica.go.jp/for/join.html'
    @elements = encode_gensenweb(search_url)
  end
  
  def crawl3
    # 入力された文字列を受け取る
    keyword = "npo"
    # 入力された文字列をgoogleで検索して1ページ目のURLを取得する
    search_urls = google_scraping(keyword)
    # 取得したURLを使って専門用語抽出サービスで用語を抽出
    @elements = []
    search_urls.each do |search_url|
      @elements += encode_gensenweb(search_url)
      # @elements.push(encode_gensenweb(search_url))
    end
    @elements.uniq!.sort!{|a, b| a.size <=> b.size}
  end

  private
  
    def google_scraping(keyword)
      agent = Mechanize.new   
      agent.get('https://www.google.co.jp/')
      agent.page.form_with(name: 'f') do |form|
        form.q = keyword
      end.submit
      agent.page.search('div.g').map do |node|
        title = node.search('a')
        next if title.empty?
        query = URI.decode_www_form(URI(title.attr("href")).query)
        url = query[0][1]
      end
    end 
    
    
    
    def gensenweb(search_url)
      agent = Mechanize.new
      agent.user_agent_alias = 'Windows IE 9'
      url = 'http://gensen.dl.itc.u-tokyo.ac.jp/gensenweb.html'
      page = agent.get(url)
      page.form_with do |f|
        f.url = search_url
        f.Sentence = ""
        f.disp = ""
      end.submit
    end
    
    def encode_gensenweb(search_url)
      begin
        @elements = gensenweb(search_url).body.encode("UTF-8", "Shift_JIS").split("\n")
      rescue Encoding::InvalidByteSequenceError
        p $!
        puts $!.error_bytes.dump unless $!.error_bytes.empty?
        puts $!.readagain_bytes.dump unless $!.readagain_bytes.empty?
      end
    end


end