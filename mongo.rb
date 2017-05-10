require './env.rb'
@client=Mongo::Client.new([ MONGO_ADD ], :database => MONGO_DB)
db=@client.database

collection=@client[:reviews]
p collection


def formatData
  
end

def createReview 

end
