
module Mantis::XSD

  class ObjectRef

    attr_accessor :id, :name

    def initialize(id, name)
      @id = id
      @name = name
    end

    # Generate an ObjectRef XSD type given an #element_name
    # that you want to tag it with.
    #
    # Let's say ObjectRef is id: 10, name: "public", and you want
    # to generate the XMl for it under the <style> attribute:
    #
    # to_xml "style"  # should yield
    #
    # <status type="tns:ObjectRef">
    #   <id>10</id>
    #   <name>public</name>
    # </status>
    def to_xml(element_name)
      builder = Nokogiri::XML::Builder.new { |xml|
        xml.send(element_name, type: "tns:ObjectRef") do 
          xml.id_ @id
          xml.name @name
        end
      }
      builder.doc.root
    end



  end
end


