module Mantis::XSD

  class CustomFieldValueForIssueData
    include Mantis::XSD::DocBuilder
    attr_accessor :field, :value

    #def initialize(params={})
      #params.each_key { |p|
        #instance_variable_set("@#{p}", params[p])
      #}
    #end

    #def document(tag_name="custom_field_value_for_issue")
      #@doc ||= to_doc(tag_name)
    #end

    def to_doc(tag_name)
      builder = Nokogiri::XML::Builder.new { |xml|
        xml.send(tag_name, type: "tns:CustomFieldValueForIssueData") do
          if @field
            xml.field(type: "tns:ObjectRef") {
              xml.id_ @field[:id]
              xml.name @field[:name]
            }
          end
          xml.value @value if @value
        end
      }
      builder.doc
    end # to_doc

    #def to_element_string(tag_name)
      #document(tag_name).root.to_s
    #end # to_element_string
  end # CustomFieldValueForIssueData
end # Mantis::XSD
