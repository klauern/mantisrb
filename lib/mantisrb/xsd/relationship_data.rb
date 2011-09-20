module Mantis::XSD

  # Relationships map one issue to another issue.  Issues can be children of
  # another issue, parents of, related to, duplicate of, and others.
  class RelationshipData

    include Mantis::XSD::DocBuilder

    attr_accessor :id, :type, :target_id

    # If you don't know what the id or type should be,
    # these are some defaults that are installed on most
    # Mantis servers.  it's not provided out-of-the-box
    # for the SOAP API, but unless a new type has been defined,
    # this should get you somewhere.
    DEFAULT_TYPES = { 2 => "parent of",
      3 => "child of",
      0 => "duplicate of",
      4 => "has duplicate",
      1 => "related to"
    }

    # Create an XML Element out of this Object instance.
    # @param [String] tag_name name of the XML element ot wrap these attributes
    # around.
    # @return [Nokogiri::XML::Document]
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
