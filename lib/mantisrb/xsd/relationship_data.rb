module Mantis::XSD

  class RelationshipData
    attr_accessor :id, :type, :target_id

    def initialize(params={})
      params.each_key { |p|
        instance_variable_set("@#{p}", params[p])
      }
    end

    def document(tag_name="relationship")
      @doc ||= to_doc(tag_name)
    end

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

    def to_element_string(tag_name)
      document(tag_name).root.to_s
    end # to_element_string
  end # RelationshipData
end # Mantis::XSD
