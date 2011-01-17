class HTTMultiParty::SpecialHash < Hash
  # pretending not to be a hash
  def is_a?(klass)
    klass == ::Hash ? false : super
  end
end
