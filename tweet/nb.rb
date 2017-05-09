require 'nbayes'

TRAIN="tweets-train.tsv"
TEST="tweets-test-set.tsv"
ALL="csv"
p "train data:"
c1=gets.chomp.to_i
case c1
when 1
  train_data=TRAIN
when 2 
  train_data=TEST
else
  train_data=ALL
end
p "test data:"
c2=gets.chomp
case c2
when 1
  test_data=TRAIN
when 2
  test_data=TEST
else
  test_data=ALL
end

nbayes = NBayes::Base.new
file=IO.readlines(train_data)
file.each do |line|
  data=line.split("\t")
  sentence=data[2].to_s
  nbayes.train(sentence.split(/\s+/), data[0].to_s)
end

truenb=0
i=0
doc=IO.readlines(test_data)
doc.each do |line|
  data=line.split("\t")
  sentence=data[2].to_s
  tokens=sentence.split(/\s+/)
  result = nbayes.classify(tokens)
  truenb=truenb+1 if(result.max_class==data[0])
  i=i+1
end
p truenb.to_f/i.to_f*100
