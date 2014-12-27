require File.join(File.dirname(__FILE__), '..', 'lib', 'httmultiparty')
require File.join(File.dirname(__FILE__), 'fixtures', 'custom_test_file')
require 'fakeweb'

def file_fixture(filename)
  open(File.join(File.dirname(__FILE__), 'fixtures', "#{filename}")).read
end

Dir[File.expand_path(File.join(File.dirname(__FILE__), 'support', '**', '*.rb'))].each { |f| require f }

RSpec.configure do |config|
  config.before { FakeWeb.allow_net_connect = false }
  config.after  { FakeWeb.allow_net_connect = true }
end
