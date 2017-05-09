print "-------------------\n"
print "Train dataset\n"
print "-------------------\n"
train_type=['camera','design','perform','general','misc']
train_type.each do |data|
  print "#{data}\t"
  data_file= "/home/ubuntu/solr/train/#{data}/#{data}.csv"
  p IO.readlines(data_file.to_s).count
end
print "-------------------\n"
