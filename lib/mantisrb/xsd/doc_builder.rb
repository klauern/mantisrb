# DocBuilder is a helper Module to make working with the XML requests/responses
# from MantisConnect simpler.  in particular, it provides mapping of
# a "tns:xxxData" type to the {Mantis::XSD} type, instantiation of the type,
# and creating/retrieval of an XML document that can be used for SOAP requests.
module Mantis::XSD::DocBuilder

  # Map an xsd type (e.g. "tns:AccountData") to a class that can be
  # instantiated (such as {Mantis::XSD::AccountData})
  TYPE_MAPPING = {
    "tns:AccountData" => Mantis::XSD::AccountData,
    "tns:AttachmentData" => Mantis::XSD::AttachmentData,
    "tns:CustomFieldForIssueData" => Mantis::XSD::CustomFieldValueForIssueData,
    "tns:FilterData" => Mantis::XSD::FilterData,
    "tns:IssueData" => Mantis::XSD::IssueData,
    "tns:IssueHeaderData" => Mantis::XSD::IssueHeaderData,
    "tns:IssueNoteData" => Mantis::XSD::IssueNoteData,
    "tns:ObjectRef" => Mantis::XSD::ObjectRef,
    "tns:ProjectAttachmentData" => Mantis::XSD::ProjectAttachmentData,
    "tns:ProjectData" => Mantis::XSD::ProjectData,
    "tns:ProjectVersionData" => Mantis::XSD::ProjectVersionData,
    "tns:RelationshipData" => Mantis::XSD::RelationshipData
  }
  
  # Create a new instance of the XSD type
  # @param [Hash] params This is usually `Savon::SOAP::XML#body`, as Savon will
  # usually parse the SOAP response into a hash that can be more easily worked
  # with in Ruby.
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

  # Get the XML Document from this XSD type.  Nokogiri will create an <xml?
  # version ...?> tag, and this will give you the raw node back for use with
  # combining with a SOAP request or inserting into the middle of an existing
  # SOAP request.
  # @param [String] tag_name tag to wrap this XSD type in, such as "issue" or
  # "project"
  # @return Nokogiri Document
  def document(tag_name)
    @doc ||= to_doc(tag_name)
  end

  # Create a Nokogiri Document that can be used in formulating the SOAP request
  # body for any given XSD type
  # @param [String] tag_name name to provide to set the wrapped tag for this
  # node
  # @param [String] type the "tns:xxxData" type to set the XML for.  This is to
  # maintain compliance with MantisConnect's requirements
  # @return Nokogiri Document 
  def to_doc(tag_name, type, &block)
    builder = Nokogiri::XML::Builder.new { |xml|
      xml.send(tag_name, type: type) do
        yield
      end
    }
    builder.doc
  end # to_doc

  # Helper method to make addressing any instance variable like working with
  # a Hash.
  # @param [Symbol] key Instance variable to get
  # @return value of instance variable
  def [](key)
    instance_variable_get("@#{key}")
  end

  # Helper method to make setting any instance variable much like working with
  # a Hash.
  # @param [Symbol] key Instance variable to set
  # @param val What to set it to
  def []=(key,val)
    instance_variable_set("@#{key}", val)
  end

  # Create the Document string for this XSD type (without the <xml?...?> )
  # @param [String] tag_name name of the tag to wrap this document in (such as
  # "issue" or "project"
  # @return [String] string of XML
  def to_element_string(tag_name)
    document(tag_name).root.to_s
  end # to_element_string
end # Mantis::XSD::DocBuilder
