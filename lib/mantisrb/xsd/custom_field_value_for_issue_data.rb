module Mantis::XSD

  # Custom Fields are defined for all projects.  Custom Fields are just
  # a designation given to define a String for a property, so you should be
  # able to get Custom Fields for any project.
  class CustomFieldValueForIssueData
    include Mantis::XSD::DocBuilder
    attr_accessor :field, :value

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
  end # CustomFieldValueForIssueData
end # Mantis::XSD
