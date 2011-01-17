class HTTMultiParty::MultipartPut < Net::HTTP::Put
  include HTTMultiParty::Multipartable
end

HTTParty::Request::SupportedHTTPMethods << HTTMultiParty::MultipartPut