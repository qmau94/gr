require './env.rb'
require './countTraindata.rb'

#getdata from solr
def getAllreview
  count=Hash.new(0)
  @response = SOLR.get 'select', :params => {:q => '*:*',:start => 0, :rows => 100, :fl => 'url,title,review,host,digest,tag,published_date,popular', :wt => 'ruby'}
  File.write(REVIEW_CSV, @response)
  print "All review has been extracted to #{REVIEW_CSV}\n"
  print "------------------\n"
  @response["response"]["docs"].each do |review|
    count[review['host'].intern]+=1
    count[:total]+=1
  end
  count.each{|v,k| print "#{v}\t#{k}\n"}
  print "------------------\n"
end

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

#TINHTE_DATA_HANDLE
#popular
def getTinhtepopular p
  begin
    return p.gsub!(".","").split(/\s+/).last.gsub!(",","")
  rescue
    0
  end
end
#tag
def getTinhtetag t
  begin
    t.split("|")
  rescue
    []
  end
end
#published_date
def getPublisheddate d
  begin
    Time.strptime(d,"%d/%m/%Y"){|year| year + ( year <70 ? 2000: 1900) }
  rescue
    ""
  end
end

def getRawhtml url
  page=Nokogiri::HTML(open(url))
  return page.css(".uix_discussionAuthor .baseHtml").to_html
end

def prepareData doc
  case doc['host']
  when "tinhte.vn"
    doc['popular']=getTinhtepopular doc['popular']
    doc['tag']=getTinhtetag doc['tag']
    doc['published_date']=getPublisheddate doc['published_date']
    doc['content']=getRawhtml doc['url']
  else
    #todo
  end
end


def classifytoMongo
  start=Time.now
  client=Mongo::Client.new([ 'localhost:27017' ], :database => 'test')
  collection=client[:reviews5131]
  result_file=File.open(RESULT_CSV,'a')
  @response['response']['docs'].each do |doc|
    begin
      tokens=doc['review'].gsub!("\n", " ").split(/\s+/)
    rescue
      tokens=Array.new(0)
    end
    result=@nbayes.classify(tokens)
    prepareData doc
    output={_id:doc['digest'],title:doc['title'],host:doc['host'],type:result.max_class,url:doc['url'],review:doc['review'],published_date:doc['published_date'],tag:doc['tag'],popular:doc['popular'],content:doc['content']}
    begin
      collection.insert_one(output)
    rescue => e
      p e
    end
  end
  p "Finished in:#{(Time.now-start).round(2)}s"
end


countTraindata
countTestdata
trainModel
testModel
getAllreview
classifytoMongo

