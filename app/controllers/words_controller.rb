class WordsController < ApplicationController
  
  def search
    @word = Word.new
    @words = Word.all
  end
  
  def create
    keyword = params[:word][:keyword]
    if @word = Word.find_by(keyword: keyword)
    else
      search_urls = google_scraping(keyword)
      elements = []
      search_urls.each do |search_url|
        next if encode_gensenweb(search_url).nil?
        elements += encode_gensenweb(search_url)[0..30]
      end
      elements.uniq!
      @word = Word.create(keyword: keyword, results: elements, saved_words:"")
    end
    redirect_to "/words/#{@word.id}/edit"
  end

  def update
  end

  def edit
    @word = Word.find(params[:id])
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
        gensenweb(search_url).body.encode("UTF-8", "Shift_JIS").split("\n")
      rescue Encoding::InvalidByteSequenceError
        p $!
        puts $!.error_bytes.dump unless $!.error_bytes. nil?
        puts $!.readagain_bytes.dump unless $!.readagain_bytes.nil?
      end
    end
    
    
end
