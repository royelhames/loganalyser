require 'ipaddress'

@name = ARGV[0]

unless @name and @name.match(".log")
  puts "Error:missing file name,should be logfile ending .log \nUsage:ruby analyser.rb filename.log"  
  exit
end

unless eval(File.exists?(@name).to_s)
  puts "Error:unknown file type, should be text \nUsage:ruby analyser.rb filename.log"
end

#split the file into an array of lines
@content = File.open(@name).readlines.map(&:chomp)

#we want to order per view
@perview = Hash.new
#also unique view
@tmp_uniqueview = Hash.new
@uniqueview = Hash.new
#also for fun fake ips
@fakeips = Array.new

@content.each do |v|
  #puts v.to_s
  #point out lines not conforming to page\sip and skip them
  unless v.match(/\w\s\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/) 
    puts "line '#{v}' not complaint with expected format" 
    next
  end
  @f = v.split("\s")
  @page = @f[0]
  @ip = @f[1]

  if @perview.key?(@page)
    @perview[@page] += 1
  else
    @perview[@page] = 1
  end

  unless @tmp_uniqueview.key?(v)
    #first time we seeing this page ip combo
    #record it

    @tmp_uniqueview[v] = 1

    if @uniqueview.key?(@page)
      @uniqueview[@page] += 1
    else
      @uniqueview[@page] = 1
    end
  end

  unless IPAddress.valid? @ip
    @fakeips.push(@ip) unless @fakeips.include? @ip
  end

end


#list per view
puts "Ordered by most page views"
@string_len = @perview.keys.max_by(&:length) 		#Helps us align things nice and neat 
printf "%-#{@string_len.length}s %s\n", "Page","Number of views"
@perview.sort_by {|k,v| v}.reverse.each do |p,n|
  printf "%-#{@string_len.length}s %s\n", p,n
end

puts ""  #Line seperator
#list per unique view
#same pages so we can use @string_len
puts "Ordered by most unique page views"
printf "%-#{@string_len.length}s %s\n", "Page","Number of unique views"
@uniqueview.sort_by {|k,v| v}.reverse.each do |up,un|
  printf "%-#{@string_len.length}s %s\n", up,un
end

puts ""  #Line seperator
puts "The below IPs are invalid"
@fakeips.each do |ip|
  puts ip.to_s 
end

