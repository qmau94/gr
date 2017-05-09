a=Array.new(5,0)
a.map!{|a| a=Array.new(5,0)}
print "category: "
category=gets.chomp.to_s
print "predicted cat:"
predict=gets.chomp.to_s

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

def rowsum a,row
  sum=0
  0.upto(4){|i| sum+=a[row][i]}
  return sum
end

def colsum a,col
  sum=0
  0.upto(4){|i| sum+=a[i][col]}
end

y=getValue(category)
x=getValue(predict)

a[x][y]+=1

categories=["camera","design","perform","general","misc"]
categories.each{|c| print "#{c}\t"}
print "<-clasified as\n"
0.upto(4) do |row|
  0.upto(4) do |col|
    print "#{a[col][row]}\t"
  end
  print "| #{rowsum(a,row)}\t#{categories[row]}\n"
end

def precision category
  x=getValue category
  y=getValue category
  return a[x][y]/colsum(a,y)
end

def recall category
  x=getValue category
  y=getValue category
  return a[x][y]/rowsum(a,x)
end
