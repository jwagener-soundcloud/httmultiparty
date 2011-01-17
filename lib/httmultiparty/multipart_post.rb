class HTTMultiParty::MultipartPost < Net::HTTP::Post
  include HTTMultiParty::Multipartable
end

HTTParty::Request::SupportedHTTPMethods << HTTMultiParty::MultipartPost