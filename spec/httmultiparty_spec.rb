require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))
gem 'httparty'
gem 'multipart-post'
require 'httparty'
require 'net/http/post/multipart'

describe HTTMultiParty do
  let(:somefile) { File.new(File.join(File.dirname(__FILE__), 'fixtures/somefile.txt')) }
  let(:klass) { Class.new.tap { |k| k.instance_eval { include HTTMultiParty} } }

  it "should include HTTParty module" do
    klass.included_modules.should include HTTParty 
  end

  it "should extend HTTParty::Request::SupportedHTTPMethods with Multipart methods" do
    HTTParty::Request::SupportedHTTPMethods.should include HTTMultiParty::MultipartPost
    HTTParty::Request::SupportedHTTPMethods.should include HTTMultiParty::MultipartPut
  end

  describe '#query_contains_files?' do
    it "should return true if one of the values in the passed hash is a file" do
      klass.send(:query_contains_files?, {:a => 1, :somefile => somefile}).should be_true
    end

    it "should return false if one of the values in the passed hash is a file" do
      klass.send(:query_contains_files?, {:a => 1, :b => 'nope'}).should be_false
    end
  end

  describe '#post' do    
    it "should respond to post" do
      klass.should respond_to :post
    end

    it "should setup new request with Net::HTTP::Post" do
      HTTParty::Request.should_receive(:new) \
        .with(Net::HTTP::Post, anything, anything) \
        .and_return(mock("mock response", :perform => nil))
      klass.post('http://example.com/', {})
    end
    
    describe 'when :query contains a file' do
      let(:query) { {:somefile => somefile } }
      
      it "should setup new request with Net::HTTP::Post::Multipart" do
        HTTParty::Request.should_receive(:new) \
          .with(HTTMultiParty::MultipartPost, anything, anything) \
          .and_return(mock("mock response", :perform => nil))
        klass.post('http://example.com/', :query => query)
      end
      
      it "should map queries with files to special body hash with upload io" do
        HTTParty::Request.should_receive(:new) \
          .with(anything, anything, {:body => hash_including({:somefile => instance_of(UploadIO)})}) \
          .and_return(mock("mock response", :perform => nil))
        klass.post('http://example.com/', :query => query)
      end
    end
  end
end