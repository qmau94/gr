require 'rsolr'
require 'open-uri'

solr = RSolr.connect :url => 'http://master:8983/solr/collection1/'
print "ID:"
id=gets.chomp.to_s
response=solr.get 'select', :params => {:q => "id:#{34.chr}#{id}#{34.chr}",:fl => 'digest,id,review', :wt => 'csv', 'csv.separator'.intern => 9.chr }

File.write('test1', response[18..-1])
