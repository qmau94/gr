train_type=['camera','design','perform','general','misc']
train_type.each do |data|
  print "#{data}\t"
  data_file= "#{data}/#{data}.csv"
  p IO.readlines(data_file.to_s).count
end
