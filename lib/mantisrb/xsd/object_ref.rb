module Mantis::XSD

  # ObjectRef is used alot in Mantis to wrap Enums and various other pieces of
  # information. An ObjectRef has an ID and a Name, and that's it. Most
  # ObjectRef's don't map to other ObjectRef's, so the ID is not to be taken as
  # canonical for all types of ObjectRef.
  class ObjectRef
    
    include Mantis::XSD::DocBuilder

    attr_accessor :id, :name

    # Generate an ObjectRef XSD type given an #element_name
    # that you want to tag it with.
    #
    # Let's say ObjectRef is id: 10, name: "public", and you want
    # to generate the XMl for it under the <style> attribute:
    #
    # to_doc "style"  # should yield
    #
    # <status type="tns:ObjectRef">
    #   <id>10</id>
    #   <name>public</name>
    # </status>
    # @param [String] element_name name of the XML node to wrap this in
    # @return [Nokogiri::XML::Document]
    def to_doc(element_name)
      builder = Nokogiri::XML::Builder.new { |xml|
        xml.send(element_name, type: "tns:ObjectRef") do 
          xml.id_ @id
          xml.name @name
        end
      }
      builder.doc.root
    end
  end # ObjectRef
end # Mantis::XSD
