require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))

describe HTTMultiParty::Multipartable do
  let :request_class do
    Class.new(Net::HTTP::Post) do
      include HTTMultiParty::Multipartable
    end
  end

  # this is how HTTParty works
  context "headers set by .body= are retained if .initialize_http_header is called afterwards" do
    def request_with_headers(headers)
      request_class.new("/path").tap do |request|
        request.body = { :some => :var }
        request.initialize_http_header(headers)
      end
    end

    context "with a header" do
      subject { request_with_headers({ "a" => "header" }).to_hash }
      it { should include("content-length") }
      it { should include("a") }
    end

    context "without a header" do
      subject { request_with_headers(nil).to_hash }
      it { should include("content-length") }
      it { should_not include("a") }
    end
  end

  # in the case of http digest authentication, body= is called with empty string for the first request
  it "should not raise an error with an empty-string body" do
    lambda {
      request = request_class.new("/path")
      request.body = ''
    }.should_not raise_error
  end

end
