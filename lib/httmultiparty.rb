gem 'httparty'
gem 'multipart-post'
require 'httparty'
require 'net/http/post/multipart'

module HTTMultiParty
  QUERY_STRING_NORMALIZER = Proc.new do |params|
    HTTMultiParty.flatten_params(params).map do |(k,v)|
      [k, v.is_a?(File) ? HTTMultiParty.file_to_upload_io(v) : v]
    end
  end

  def self.included(base)
    base.send :include, HTTParty
    base.extend ClassMethods
  end

  def self.file_to_upload_io(file)
    filename =  File.split(file.path).last
    content_type = 'application/octet-stream'
    UploadIO.new(file, content_type, filename)
  end

  def self.flatten_params(params={}, prefix='')
    flattened = []
    params.each do |(k,v)|
      if params.is_a?(Array)
        v = k
        k = ""
      end

      flattened_key = prefix == "" ? "#{k}" : "#{prefix}[#{k}]"
      if v.is_a?(Hash) || v.is_a?(Array)
        flattened += flatten_params(v, flattened_key)
      else
        flattened << [flattened_key, v]
      end
    end
    flattened
  end

   module ClassMethods
     def post(path, options={})
       method = Net::HTTP::Post
       options[:body] ||= options.delete(:query)
       if hash_contains_files?(options[:body])
         method = MultipartPost
         options[:query_string_normalizer] = HTTMultiParty::QUERY_STRING_NORMALIZER
       end
       perform_request method, path, options
     end

     def put(path, options={})
       method = Net::HTTP::Put
       options[:body] ||= options.delete(:query)
       if hash_contains_files?(options[:body])
         method = MultipartPut
         options[:query_string_normalizer] = HTTMultiParty::QUERY_STRING_NORMALIZER
       end
       perform_request method, path, options
     end

    private
      def hash_contains_files?(hash)
        hash.is_a?(Hash) && HTTMultiParty.flatten_params(hash).select do |(k,v)| 
          v.is_a?(File) || v.is_a?(UploadIO)
        end.size > 0
      end
   end
end

require 'httmultiparty/version'
require 'httmultiparty/multipartable'
require 'httmultiparty/multipart_post'
require 'httmultiparty/multipart_put'
