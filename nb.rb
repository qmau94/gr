require 'nbayes'
TRAIN="traincsv1"
TEST=""
ALL=""


nbayes = NBayes::Base.new
file=IO.readlines(TRAIN)
lines=file.count
p lines
p "no of row to train data:"
train_no=gets.chomp.to_i
file[0..train_no].each do |line|
  data=line.split("\t")
  sentence=data[2].to_s
  nbayes.train(sentence.split(/\s+/), data[0].to_s)
end

file[train_no..lines].each do |line|
  data=line.split("\t")
  sentence=data[1].to_s
  tokens=sentence.split(/\s+/)
  result = nbayes.classify(tokens)
  p data[0]
  p result.max_class
end
