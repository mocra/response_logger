require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ResponseLogger" do
  before do
    @path = File.join(RAILS_ROOT, "log", Date.today.strftime("%Y/%m/%d"))
  end
  
  def logged_files
    Dir["#{@path}/**/*"].select { |item| File.file?(item) }
  end
  
  def response_check(logged_files, response)
    File.read(logged_files.first).should(eql(response.body), "The logged file does not contain the same text as response body")
  end
  
  describe "Logging" do
    
    before do
      logged_files.size.should eql(0)
    end
    
    describe "Net::HTTP" do
      describe "#get" do
        it "root requests" do
          logged_files.size.should eql(0)
          Net::HTTP.get(URI.parse("http://github.com/"))
          logged_files.size.should eql(1)
          logged_files.detect { |file| /github\.com\/.*?/.match(file) }.should_not be_nil
        end
      end
      
      describe "#new" do
        it "works with SSL" do
          logged_files.size.should eql(0)
          url = URI.parse('https://github.com/login')
          http = Net::HTTP.new(url.host, 443)
          req = Net::HTTP::Get.new(url.path)
          http.use_ssl = true
          
          text = "Log in - GitHub"
          
          response = http.request(req)
          response.class.should eql(Net::HTTPOK)
          
          logged_files.size.should eql(1)
          logged_files.detect { |file| /login\/\d+/.match(file) }.should_not be_nil
          response_check(logged_files, response)
        end
        
        it "works without SSL" do
          logged_files.size.should eql(0)
          url = URI.parse('https://github.com/')
          http = Net::HTTP.new(url.host, 80)
          req = Net::HTTP::Get.new(url.path)
          
          text = "Secure source code hosting and collaborative development - GitHub"
          
          response = http.request(req)
          response.class.should eql(Net::HTTPOK)
          
          logged_files.size.should eql(1)
          logged_files.detect { |file| /github\.com\/\d+/.match(file) }.should_not be_nil
          response_check(logged_files, response)
        end
      end
    end
    
  end
  

end