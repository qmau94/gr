file=IO.readlines("test_data.csv")
afile=File.open("test",'a')
file.each do |line|
  data=line.split("\t")
  data.delete_at(2)
  data[0..-2].each{|x| afile.print("#{x}\t")}
  afile.print("#{data.last}")
end
