require './env.rb'

def getAllreview
  count=Hash.new(0)
  response = SOLR.get 'select', :params => {:q => '*:*',:start => 0, :rows => ALL, :fl => 'url,title,review,host,digest,tag,published_date,popular', :wt => 'ruby'}
  File.write(REVIEW_CSV, response)
  print "All review has been extracted to #{REVIEW_CSV}\n"
  print "------------------\n"
  response["response"]["docs"].each do |review|
    count[review['host'].intern]+=1
    count[:total]+=1
  end
  count.each{|v,k| print "#{v}\t#{k}\n"}
  print "------------------\n"
end

getAllreview



