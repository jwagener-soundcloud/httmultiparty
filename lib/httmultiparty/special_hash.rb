# SpecialHash is a hash that is pretending to be not a Hash.
# its just a cheap way to get around the query normalization
# happening in HTTParty::Request#body in lib/httparty/request.rb:118
class HTTMultiParty::SpecialHash < Hash
  def is_a?(klass)
    klass == ::Hash ? false : super
  end
end
