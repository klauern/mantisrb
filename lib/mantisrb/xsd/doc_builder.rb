module Mantis::XSD::DocBuilder

  TYPE_MAPPING = {
    "tns:AccountData" => Mantis::XSD::AccountData,
    "tns:AttachmentData" => Mantis::XSD::AttachmentData,
    "tns:CustomFieldForIssueData" => Mantis::XSD::CustomFieldValueForIssueData,
    "tns:FilterData" => Mantis::XSD::FilterData,
    "tns:IssueData" => Mantis::XSD::IssueData,
    "tns:IssueHeaderData" => Mantis::XSD::IssueHeaderData,
    "tns:IssueNoteData" => Mantis::XSD::IssueNoteData,
    "tns:ObjectRef" => Mantis::XSD::ObjectRef,
    "tns:ProjectData" => Mantis::XSD::ProjectData,
    "tns:RelationshipData" => Mantis::XSD::RelationshipData
  }
  
  def initialize(params={})
    params.each_key { |p|
      if p == "@xsi:type" && TYPE_MAPPING[params["@xsi:type"]]
        #puts "Found an awesomely mappable type, let's go"
        instance_variable_set("@#{p}", TYPE_MAPPING[p["@xsi:type"]].send(:new, params[p]))
      else
        #puts "Just A regular type, we'll just go with the flow"
        instance_variable_set("@#{p}", params[p])
      end
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
