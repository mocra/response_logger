require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ResponseLogger" do
  before do
    @path = File.join(RAILS_ROOT, "log", Date.today.strftime("%Y/%m/%d"))
  end
  
  def logged_files
    Dir["#{@path}/**/*"].select { |item| File.file?(item) }
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
          response = http.request(req)
          response.class.should eql(Net::HTTPOK)
          response.body.should include("Log in - GitHub")
          logged_files.size.should eql(1)
          logged_files.detect { |file| /login\/\d+/.match(file) }.should_not be_nil
        end
        
        it "works without SSL" do
          logged_files.size.should eql(0)
          url = URI.parse('https://github.com/')
          http = Net::HTTP.new(url.host, 80)
          req = Net::HTTP::Get.new(url.path)
          response = http.request(req)
          response.class.should eql(Net::HTTPOK)
          response.body.should include("Secure source code hosting and collaborative development - GitHub")
          logged_files.size.should eql(1)
          logged_files.detect { |file| /github\.com\/\d+/.match(file) }.should_not be_nil
        end
      end
    end
    
  end
  

end