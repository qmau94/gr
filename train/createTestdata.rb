require 'rsolr'
require 'open-uri'

solr = RSolr.connect :url => 'http://master:8983/solr/collection1/'
print "Category:"
category=gets.chomp.to_s
file_name="test_data/test_data.csv"
f=File.open(file_name, 'a')
while 1 do
  print "Id:"
  id=gets.chomp.to_s
  response=solr.get 'select', :params => {:q => "id:#{34.chr}#{id}#{34.chr}", :fl => 'digest,id,review', :wt => 'csv', 'csv.separator'.intern => 9.chr }
  content=category+"#{9.chr}"+response[18..-1]
  f.puts(content)
end

