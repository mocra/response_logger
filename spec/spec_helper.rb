$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

begin
  require 'rubygems'
rescue LoadError
  puts "Alright, no rubygems? No worries!"
end
require 'response_logger'
require 'spec'
require 'spec/autorun'
require 'fileutils'

RAILS_ROOT = File.dirname(__FILE__)

Spec::Runner.configure do |config|
  config.before(:each) do
    FileUtils.rm_rf(File.join(RAILS_ROOT, "log"))
  end
end
