require 'nbayes'
TRAIN="train/train05092"
TEST="test1"
ALL=""


nbayes = NBayes::Base.new
file=IO.readlines(TRAIN)
file.each do |line|
  data=line.split("\t")
  sentence=data[3].to_s
  nbayes.train(sentence.split(/\s+/), data[0].to_s)
end
i=0

file=IO.readlines(TEST)
lines=file.count
file.each do |line|
  data=line.split("\t")
  sentence=data[3].to_s
  tokens=sentence.split(/\s+/)
  result = nbayes.classify(tokens)
  if(data[0]==result.max_class)
    i=i+1
  else
    p "----"
    p data[2]
    p data[0]
    p result
    p result.max_class
  end
end

p i.to_f/lines.to_f * 100
