
require './env.rb'

def getAllreview
  response = SOLR.get 'select', :params => {:q => '*:*',:start => 0, :rows => 13964, :fl => 'host,id,review,digest,tstamp', :wt => 'csv', 'csv.separator'.intern => 9.chr }
  File.write(REVIEW_CSV, response[29..-1])
  print "All review has been extracted to #{REVIEW_CSV}\n"
  print "------------------\n"
end

def getReviewtype file
  count=Hash.new(0)
  file.each do |line|
    data=line.split("\t")
    count[data[HOST_DATA_INDEX].intern]+=1
  end  
  count.each{|v,k| print "#{v}\t#{k}\n"}
  print "------------------\n"
  print "Total: #{file.count}\n"
  print "------------------\n"
end

getAllreview
getReviewtype IO.readlines(REVIEW_CSV)



