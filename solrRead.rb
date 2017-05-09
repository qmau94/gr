require 'rsolr'
require 'open-uri'

solr = RSolr.connect :url => 'http://master:8983/solr/collection1/'

response = solr.get 'select', :params => {:q => '*:*',:start => 0, :rows => 9387, :fl => 'id', :wt => 'csv', 'csv.separator'.intern => 9.chr }

File.write('csv', response)
