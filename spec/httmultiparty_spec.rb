require File.expand_path(File.join(File.dirname(__FILE__), 'spec_helper'))
gem 'httparty'
gem 'multipart-post'
require 'httparty'
require 'net/http/post/multipart'

describe HTTMultiParty do
  let(:somefile) { File.new(File.join(File.dirname(__FILE__), 'fixtures/somefile.txt')) }
  let(:somejpegfile) { File.new(File.join(File.dirname(__FILE__), 'fixtures/somejpegfile.jpeg')) }
  let(:somepngfile) { File.new(File.join(File.dirname(__FILE__), 'fixtures/somepngfile.png')) }
  let(:sometempfile) { Tempfile.new('sometempfile') }
  let(:customtestfile) { CustomTestFile.new(File.join(File.dirname(__FILE__), 'fixtures/somefile.txt')) }
  let(:someuploadio) { UploadIO.new(somefile, "application/octet-stream") }
  let(:klass) { Class.new.tap { |k| k.instance_eval { include HTTMultiParty} } }

  it "should include HTTParty module" do
    klass.included_modules.should include HTTParty
  end

  it "should extend HTTParty::Request::SupportedHTTPMethods with Multipart methods" do
    HTTParty::Request::SupportedHTTPMethods.should include HTTMultiParty::MultipartPost
    HTTParty::Request::SupportedHTTPMethods.should include HTTMultiParty::MultipartPut
    HTTParty::Request::SupportedHTTPMethods.should include HTTMultiParty::MultipartPatch
  end

  describe '#hash_contains_files?' do
    it "should return true if one of the values in the passed hash is a file" do
      klass.send(:hash_contains_files?, {:a => 1, :somefile => somefile}).should be_true
    end

    it "should return true if one of the values in the passed hash is an upload io " do
      klass.send(:hash_contains_files?, {:a => 1, :somefile => someuploadio}).should be_true
    end

    it "should return true if one of the values in the passed hash is a tempfile" do
      klass.send(:hash_contains_files?, {:a => 1, :somefile => sometempfile}).should be_true
    end

    it "should return false if none of the values in the passed hash is a file" do
      klass.send(:hash_contains_files?, {:a => 1, :b => 'nope'}).should be_false
    end

    it "should return true if passed hash includes an a array of files" do
      klass.send(:hash_contains_files?, {:somefiles => [somefile, somefile]}).should be_true
    end

    it "should return true if passed hash includes a hash with an array of files" do
      klass.send(:hash_contains_files?, {:somefiles => {:in_here => [somefile, somefile]}}).should be_true
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
    end

    describe 'when :body contains a file' do
      let(:body) { {:somefile => somefile } }

      it "should setup new request with Net::HTTP::Post::Multipart" do
        HTTParty::Request.should_receive(:new) \
          .with(HTTMultiParty::MultipartPost, anything, anything) \
          .and_return(mock("mock response", :perform => nil))
        klass.post('http://example.com/', :body => body)
      end
    end

    describe 'with default_params' do
      let(:body) { { somefile: somefile } }

      it 'should include default_params also' do
        klass.tap do |c|
          c.instance_eval { default_params(token: 'fake') }
        end

        FakeWeb.register_uri(:post, 'http://example.com?token=fake', body: 'hello world')

        klass.post('http://example.com', body: body)
      end
    end
  end

  describe '#patch' do
    it "should respond to patch" do
      klass.should respond_to :post
    end

    it "should setup new request with Net::HTTP::Patch" do
      HTTParty::Request.should_receive(:new) \
        .with(Net::HTTP::Patch, anything, anything) \
        .and_return(mock("mock response", :perform => nil))
      klass.patch('http://example.com/', {})
    end

    describe 'when :query contains a file' do
      let(:query) { {:somefile => somefile } }

      it "should setup new request with Net::HTTP::Patch::Multipart" do
        HTTParty::Request.should_receive(:new) \
          .with(HTTMultiParty::MultipartPatch, anything, anything) \
          .and_return(mock("mock response", :perform => nil))
        klass.patch('http://example.com/', :query => query)
      end
    end

    describe 'when :body contains a file' do
      let(:body) { {:somefile => somefile } }

      it "should setup new request with Net::HTTP::Patch::Multipart" do
        HTTParty::Request.should_receive(:new) \
          .with(HTTMultiParty::MultipartPatch, anything, anything) \
          .and_return(mock("mock response", :perform => nil))
        klass.patch('http://example.com/', :body => body)
      end
    end

    describe 'with default_params' do
      let(:body) { { somefile: somefile } }

      it 'should include default_params also' do
        klass.tap do |c|
          c.instance_eval { default_params(token: 'fake') }
        end

        FakeWeb.register_uri(:patch, 'http://example.com?token=fake', body: 'hello world')

        klass.patch('http://example.com', body: body)
      end
    end
  end

  describe "#file_to_upload_io" do
    it "should get the physical name of a file" do
      HTTMultiParty.file_to_upload_io(somefile)\
        .original_filename.should == 'somefile.txt'
    end

    it "should get the physical name of a file" do
      # Let's pretend this is a file upload to a rack app.
      sometempfile.stub(:original_filename => 'stuff.txt')
      HTTMultiParty.file_to_upload_io(sometempfile)\
        .original_filename.should == 'stuff.txt'
    end

    it "should get the content-type of a JPEG file" do
      HTTMultiParty.file_to_upload_io(somejpegfile, true)\
        .content_type.should == 'image/jpeg'
    end

    it "should get the content-type of a PNG file" do
      HTTMultiParty.file_to_upload_io(somepngfile, true)\
        .content_type.should == 'image/png'
    end

    it "should get the content-type of a JPEG file as 'application/octet-stream' by default" do
      HTTMultiParty.file_to_upload_io(somejpegfile)\
        .content_type.should == 'application/octet-stream'
    end

    it "should get the content-type of a PNG file as 'application/octet-stream' by default" do
      HTTMultiParty.file_to_upload_io(somepngfile)\
        .content_type.should == 'application/octet-stream'
    end
  end

  describe "#flatten_params" do
    it "should handle complex hashs" do
      HTTMultiParty.flatten_params({
        :foo => 'bar',
        :deep => {
          :deeper  => 1,
          :deeper2 => 2,
          :deeparray => [1,2,3],
          :deephasharray => [
            {:id => 1},
            {:id => 2}
          ]
        }
      }).sort_by(&:join).should == [
        ['foo',                         'bar'],
        ['deep[deeper]',                1],
        ['deep[deeper2]',               2],
        ['deep[deeparray][]',           1],
        ['deep[deeparray][]',           2],
        ['deep[deeparray][]',           3],
        ['deep[deephasharray][][id]',   1],
        ['deep[deephasharray][][id]',   2],
      ].sort_by(&:join)
    end
  end

  describe "#query_string_normalizer" do
    subject { HTTMultiParty.query_string_normalizer }
    it "should map a file to UploadIO" do
      (first_k, first_v) = subject.call({
        :file => somefile
      }).first

      first_v.should be_an UploadIO
    end

    it "should use the same UploadIO" do
      (first_k, first_v) = subject.call({
        :file => someuploadio
      }).first

      first_v.should eq(someuploadio)
    end

    it "should map a Tempfile to UploadIO" do
      (first_k, first_v) = subject.call({
        :file => sometempfile
      }).first

      first_v.should be_an UploadIO
    end

    it "should map a CustomTestfile to UploadIO" do
      (first_k, first_v) = subject.call({
        :file => customtestfile
      }).first

      first_v.should be_an UploadIO
    end

    it "should map an array of files to UploadIOs" do
      subject.call({
        :file => [somefile, sometempfile]
      }).each { |(k,v)| v.should be_an UploadIO }
    end

    it "should map files in nested hashes to UploadIOs" do
      (first_k, first_v) = subject.call({
        :foo => { :bar => { :baz => somefile } }
      }).first

      first_v.should be_an UploadIO
    end

    it 'parses file and non-file parameters properly irrespective of their position' do
      response = subject.call(
        :name  => 'foo',
        :file  => somefile,
        :title => 'bar'
      )
      response.first.should == ['name', 'foo']
      response.last.should  == ['title', 'bar']
    end

    describe "when :detect_mime_type is true" do
      subject  { HTTMultiParty.query_string_normalizer(detect_mime_type: true) }

      it "should map an array of files to UploadIOs with the correct mimetypes" do
        result = subject.call({
          :file => [somejpegfile, somepngfile]
        })

        content_types = result.map { |(k,v)| v.content_type  }

        content_types.should == ['image/jpeg', 'image/png']
      end
    end

    describe "when :multipart is true" do
      subject  { HTTMultiParty.query_string_normalizer(multipart: true) }

      it "should map non-file parameters into key-value array pairs" do
        result = subject.call({
          :foo => 'foo value',
          :bar => 'bar value'
        })

        result.should == [['foo', 'foo value'], ['bar', 'bar value']]
        
      end
    end

    describe "when :multipart is false" do
      subject  { HTTMultiParty.query_string_normalizer(multipart: false) }

      it "should map non-file parameters into key-value string pairs" do
        result = subject.call({
          :foo => 'foo value',
          :bar => 'bar value'
        })

        result.should == ['foo=foo value', 'bar=bar value']
        
      end
    end
  end
end
