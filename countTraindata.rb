require './env.rb'

def countTraindata 
  sum=0
  CATEGORIES.each do |data|
    print "#{data}\t"
    data_file= "/home/ubuntu/solr/train/#{data}/#{data}.csv"
    p i=IO.readlines(data_file.to_s).count
    sum+=i
  end
  print "-------------------\n"
  print "Total train set: #{sum}\n" 
  print "-------------------\n"
end

def countTestdata
  count=Hash.new(0)
  file=IO.readlines(TEST)
  file.each do |line|
    data=line.split("\t")
    count[data[0].intern]+=1
  end
  count.each{|v,k| print "#{v}\t#{k}\n"}
  print "------------------\n"
  print "Total test set: #{file.count}\n"
  print "------------------\n"
end
