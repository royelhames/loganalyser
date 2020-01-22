$:.unshift(File.expand_path('../lib', File.dirname(__FILE__)))
require 'log_file'

describe LogFile do   
  context "when testing the LogFile class" do

    it "should raise File does n't exit or not a regular file" do
      expect {LogFile.new("")}.to raise_error(LogFileError,"File does n't exit or not a regular file")
    end

    it "should raise empty file error" do
      expect {LogFile.new("webserver2.log")}.to raise_error(LogFileError,"Empty file")
    end


    it "should have path " do
      lf = LogFile.new("webserver.log")
      path = lf.path
      expect(path).to eq "webserver.log"
    end


  end

end
