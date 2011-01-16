require File.join(File.dirname(__FILE__), '..', 'lib', 'httmultiparty')
#require 'spec/autorun'
require 'fakeweb'

def file_fixture(filename)
  open(File.join(File.dirname(__FILE__), 'fixtures', "#{filename.to_s}")).read
end

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

RSpec.configure do |config|
  config.before do
    FakeWeb.allow_net_connect = false
  end
  config.after do
    FakeWeb.allow_net_connect = true
  end
end
