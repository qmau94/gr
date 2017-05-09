require 'nokogiri'
require 'open-uri'
base_url="https://tinhte.vn/forums/wp-tin-tuc-danh-gia.11/page-"
hrefs=[]
file=File.open("tt_winphone_urls", 'w')

1.upto(40) do |i|
  url=base_url + i.to_s + "?order=view_count"
  page=Nokogiri::HTML(open(url))
  doc=page.css(".titleText .title")
  hrefs= hrefs + doc.css("a").map { |a|
    a["href"]
  }.compact.uniq
end

hrefs.each do |href|
  url="https://tinhte.vn/" + href
  file.puts(url)  
end

