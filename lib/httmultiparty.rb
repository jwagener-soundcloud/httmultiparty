gem 'httparty'
gem 'multipart-post'
require 'httparty'
require 'net/http/post/multipart'

HTTParty::Request::SupportedHTTPMethods << Net::HTTP::Post::Multipart
HTTParty::Request::SupportedHTTPMethods << Net::HTTP::Put::Multipart

module HTTMultiParty
  VERSION          = "0.6.1".freeze
  def self.included(base)
    base.send :include, HTTParty
    #base.send :alias_method, :httparty_post, :post
    base.extend ClassMethods
  end

   module ClassMethods
     def post(path, options={})
       method = Net::HTTP::Post
       if query_contains_files?(options[:query])
         method = method::Multipart
         map_files_to_upload_io!(options[:query])
       end
       perform_request method, path, options
     end

     def put(path, options={})
       #perform_request Net::HTTP::Put, path, options
     end
     
    private
      def query_contains_files?(query)
        query.is_a?(Hash) && query.select { |k,v| v.is_a?(File) }.length > 0
      end
      
      def map_files_to_upload_io!(hash)
        hash.each do |k,v|
          hash[k] = file_to_upload_io(v) if v.is_a?(File)
        end
      end
      
      def file_to_upload_io(file)
        filename =  File.split(file.path).last
        content_type = 'application/octet-stream'
        UploadIO.new(file, content_type, filename)
      end
   end
end


class TestParty
  include HTTMultiParty
end