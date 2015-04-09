class HTTMultiParty::MultipartPatch < Net::HTTP::Patch
  include HTTMultiParty::Multipartable
end

HTTParty::Request::SupportedHTTPMethods << HTTMultiParty::MultipartPatch
