module HTTMultiParty::Multipartable
  DEFAULT_BOUNDARY = "-----------RubyMultipartPost"
  # prevent reinitialization of headers
  def initialize_http_header(initheader)
    super if @header.nil?
  end

  def body=(value)
    boundary = DEFAULT_BOUNDARY
    parts = value.map {|(k,v)| Parts::Part.new(boundary, k, v)}
    parts << Parts::EpiloguePart.new(boundary)
    self.set_content_type("multipart/form-data", { "boundary" => boundary })
    self.content_length = parts.inject(0) {|sum,i| sum + i.length }
    self.body_stream = CompositeReadIO.new(*parts.map(&:to_io))
  end
end
