module Mantis::XSD

  class RelationshipData

    include Mantis::XSD::DocBuilder

    attr_accessor :id, :type, :target_id

    def to_doc(tag_name)
      builder = Nokogiri::XML::Builder.new { |xml|
        xml.send(tag_name, type: "tns:RelationshipData") do
          xml.id_ @id if @id
          if @type
            xml.type(type: "tns:ObjectRef") {
              xml.id_ @type[:id]
              xml.name @type[:name]
            }
          end
          xml.target_id @target_id if @target_id
        end
      }
      builder.doc
    end # to_doc

  end # RelationshipData
end # Mantis::XSD
