require './env.rb'
require './countTraindata.rb'

#get value of row and column
def getValue category
  case category
  when "camera"
    return 0
  when "design"
    return 1
  when "perform"
    return 2
  when "general"
    return 3
  when "misc"
    return 4
  end
end
#sum of row and col funtions
def rowsum a,row
  sum=0
  0.upto(4){|i| sum+=a[row][i]}
  return sum.to_f
end

def colsum a,col
  sum=0
  0.upto(4){|i| sum+=a[i][col]}
  return sum.to_f
end

#precision and recall functions and fmeasure
def precision category,a
  x=getValue category
  y=getValue category
  return a[x][y]/colsum(a,y).to_f
end

def recall category,a
  x=getValue category
  y=getValue category
  return a[x][y]/rowsum(a,x).to_f
end

def fmeasure category,a
  p=precision(category,a)
  r=recall(category,a)
  return 2*p*r/(p+r)
end

#accuracy
def accuracy a,sum
  tp=0
  0.upto(4){|i| tp+=a[i][i]}
  return tp/sum.to_f*100
end

def trainModel
  #train the nb model
  @nbayes = NBayes::Base.new
  file=IO.readlines(TRAIN)
  file.each do |line|
    data=line.split("\t")
    sentence=data[3].to_s
    @nbayes.train(sentence.split(/\s+/), data[0].to_s)
  end
end

def testModel
  # creat a 2d array to store nb classifier
  a=Array.new(5,0)
  a.map!{|a| a=Array.new(5,0)}
  file=IO.readlines(TEST)
  lines=file.count
  file.each do |line|
    data=line.split("\t")
    sentence=data[3].to_s
    tokens=sentence.split(/\s+/)
    result = @nbayes.classify(tokens)
    x=getValue result.max_class #classified category
    y=getValue data[0] #test category
    a[x][y]+=1
    unless(data[0]==result.max_class)
#      p "----"
#      p data[2]
#      p data[0] #cat
#      p result #predicted clas
#      p result.max_class
    end
  end
  print "Confusion matrix\n"
  print "-------------------\n"
  #header
  CATEGORIES.each{|c| print "#{c}\t"}
  print "<-clasified as\n"
  #2d array
  0.upto(4) do |row|
    0.upto(4) do |col|
      print "#{a[col][row]}\t"
    end
    print "| #{rowsum(a,row).to_i}\t#{CATEGORIES[row]}\n"
  end
  print "-------------------\n"

  #precision and recall
  CATEGORIES.each do |c|
    print "#{c}\tp:#{precision(c,a).to_f.round(4)*100}%"
    print " | r:#{recall(c,a).to_f.round(4)*100}%"
    print " | f:#{fmeasure(c,a).round(3)}\n"
  end
  print "-------------------\n"
  print "Accuracy: #{accuracy(a,lines).round(2)}%\n"
end

def classifytoText
  start_time=Time.now
  result_file=File.open(RESULT_CSV,'a')
  file=IO.readlines(REVIEW_CSV)
  trainModel
  file.each do |line|
    data=line.split("\t")
    sentence=data[REVIEW_DATA_INDEX].to_s
    tokens=sentence.split(/\s+/)
    result=@nbayes.classify(tokens)
    data.unshift(result.max_class.to_s)
    0.upto(4).each{|i| result_file.print("#{data[i]}\t")}
    result_file. print("#{data[5]}")
  end
  print "Finished in: #{Time.now-start_time.round(2)}s\n"
end


def classifytoMongo
  start=Time.now
  @client=Mongo::Client.new([ MONGO_ADD ], :database => MONGO_DB)
  db=@client.database
  collection=@client[:reviews]
  result_file=File.open(RESULT_CSV,'a')
  trainModel
  file=IO.readlines(REVIEW_CSV)
  file.each do |line|
    data=line.split("\t")
    sentence=data[REVIEW_DATA_INDEX].to_s
    tokens=sentence.split(/\s+/)
    result=@nbayes.classify(tokens)
    data.unshift(result.max_class)
    doc={_id:data[4],host:data[1],type:data[0],url:data[2],review:data[3],tstamp:data[5]}
    result= collection.insert_one(doc)
  end
  p "Finished in:#{Time.now-start}s"
end
classifytoMongo
