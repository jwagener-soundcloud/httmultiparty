module HTTMultiParty::Multipartable
  DEFAULT_BOUNDARY = "-----------RubyMultipartPost"
  # prevent reinitialization of headers
  def initialize_http_header(initheader)
    super
    set_headers_for_body
  end

  def body=(value)
    if value == ''
      super
    else
      @body_parts = value.map {|(k,v)| Parts::Part.new(boundary, k, v)}
      @body_parts << Parts::EpiloguePart.new(boundary)
    end

    set_headers_for_body
  end

  def boundary
    DEFAULT_BOUNDARY
  end

private

  def set_headers_for_body
    if @body_parts
      self.set_content_type("multipart/form-data", { "boundary" => boundary })
      self.content_length = @body_parts.inject(0) {|sum,i| sum + i.length }
      self.body_stream = CompositeReadIO.new(*@body_parts.map { |part| part.to_io })
    end
  end
end
