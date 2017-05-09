require 'rsolr'
require 'open-uri'

solr = RSolr.connect :url => 'http://master:8983/solr/collection1/'

response = solr.get 'select', :params => {:q => '*:*',:start => 9387, :rows => 2400, :fl => 'id', :wt => 'csv', 'csv.separator'.intern => 9.chr }

File.write('csv2', response)
