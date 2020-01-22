#!/usr/bin/env ruby
# encoding: utf-8

$:.unshift(File.expand_path('lib', File.dirname(__FILE__)))

require 'log_file'


begin
  @logfile = LogFile.new(ARGV[0]).file  
  @content = @logfile.readlines.map(&:chomp)
 
  #we want to order per view
  @perview = Hash.new
  ##also unique view
  @tmp_uniqueview = Hash.new
  @uniqueview = Hash.new
   
  @content.each do |v|
    #point out lines not conforming to 'page'\s'ip' and skip them
    unless v.match(/\w\s\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/) 
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
      #
      @tmp_uniqueview[v] = 1

      if @uniqueview.key?(@page)
        @uniqueview[@page] += 1
      else
        @uniqueview[@page] = 1
      end
    end 
  end

  #presentation
  #list per view
  puts "Ordered by most page views"
  @string_len = @perview.keys.max_by(&:length)            #Helps us align things nice and neat 
  printf "%-#{@string_len.length}s %s\n", "Page","Number of views"
  @perview.sort_by {|k,v| v}.reverse.each do |p,n|
    printf "%-#{@string_len.length}s %s\n", p,n
  end

  puts ""  #Line seperator 

  #list per unique view
  #same pages so we can use @string_len as tab length
  puts "Ordered by most unique page views"
  printf "%-#{@string_len.length}s %s\n", "Page","Number of unique views"
  @uniqueview.sort_by {|k,v| v}.reverse.each do |up,un|
    printf "%-#{@string_len.length}s %s\n", up,un
  end

 
rescue => err
  puts "ARGUMENT ERROR: " + err.message if err.message
  puts
  puts "Usage: ruby log-analyzer logfile.log"

end 
