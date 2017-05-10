require './env.rb'

def countData 
  print "-------------------\n"
  print "Train dataset\n"
  print "-------------------\n"
  CATEGORIES.each do |data|
    print "#{data}\t"
    data_file= "/home/ubuntu/solr/train/#{data}/#{data}.csv"
    p IO.readlines(data_file.to_s).count
  end 
  print "-------------------\n"
end

countData
