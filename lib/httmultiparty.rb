gem 'httparty'
gem 'multipart-post'
require 'httparty'
require 'net/http/post/multipart'

module HTTMultiParty
  def self.included(base)
    base.send :include, HTTParty
    base.extend ClassMethods
  end

   module ClassMethods
     def post(path, options={})
       method = Net::HTTP::Post
       if query_contains_files?(options[:query])
         method = MultipartPost
         options[:body] = map_files_to_upload_io(options.delete(:query))
       end
       perform_request method, path, options
     end

     def put(path, options={})
       method = Net::HTTP::Put
       if query_contains_files?(options[:query])
         method = MultipartPut
         options[:body] = map_files_to_upload_io(options.delete(:query))
       end
       perform_request method, path, options
     end

    private
      def query_contains_files?(query)
        query.is_a?(Hash) && query.select { |k,v| v.is_a?(File) }.length > 0
      end

      def map_files_to_upload_io(hash)
        new_special_hash = SpecialHash.new
        hash.each do |k,v|
          new_special_hash[k] = v.is_a?(File) ? file_to_upload_io(v) : v
        end
        new_special_hash
      end

      def file_to_upload_io(file)
        filename =  File.split(file.path).last
        content_type = 'application/octet-stream'
        UploadIO.new(file, content_type, filename)
      end
   end
end

dir = Pathname(__FILE__).dirname.expand_path
require dir + 'httmultiparty/multipartable'
require dir + 'httmultiparty/special_hash'
require dir + 'httmultiparty/multipart_post'
require dir + 'httmultiparty/multipart_put'
