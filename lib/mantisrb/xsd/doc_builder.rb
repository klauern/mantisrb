module Mantis::XSD::DocBuilder

  def initialize(params={})
    params.each_key { |p|
      instance_variable_set("@#{p}", params[p])
    }
  end

  def document(tag_name)
    @doc ||= to_doc(tag_name)
  end

  def to_doc(tag_name, type, &block)
    builder = Nokogiri::XML::Builder.new { |xml|
      xml.send(tag_name, type: type) do
        yield
      end
    }
    builder.doc
  end # to_doc

  def [](key)
    instance_variable_get("@#{key}")
  end

  def []=(key,val)
    instance_variable_set("@#{key}", val)
  end

  def to_element_string(tag_name)
    document(tag_name).root.to_s
  end # to_element_string

end # Mantis::XSD::DocBuilder
