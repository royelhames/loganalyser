require 'mimemagic'
class LogFile
  attr_reader :path
  attr_reader :status
  attr_reader :file  

  def initialize(path)
    @path = path
    @status = status
    @file = file
  end 

  def status
    status = true
    unless eval(File.exists?(@path.to_s).to_s)
      status = nil
      raise LogFileError,"File does n't exit or not a regular file"
    end
  
    if File.size(@path.to_s).to_i == 0
      status = nil
      raise LogFileError,"Empty file"
    end
  end

  def file
     file = File.new(@path)
  end
end

class LogFileError < StandardError
   
end

