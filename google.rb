require 'mechanize' 
                         
  class GoogleSearch
    def snipet_scraping(keyword)
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

       snipped = node.search('div.s > span.st')
       next if snipped.empty? || snipped.children.empty?
       { url: url }
     end.reject do |list|
       list.nil?
     end
   end 

   private

   def submit_keyword(keyword)
      agent = Mechanize.new   
      agent.get('https://www.google.co.jp/')
      agent.page.form_with(name: 'f') do |form|
        form.q = keyword
      end.submit
    end

   def expect_tag(str)
     str.gsub(/(<b>|<\/b>|<br>|<\/br>|\R)/, '')
   end
   
 end
 
 result = GoogleSearch.new.snipet_scraping("国際協力")
 result.each do |value|
   p value[:url]
end