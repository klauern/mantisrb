module Mantis::XSD

  # Filter Information is provided here, such as the string used to search for
  # it, and the URL that you cna use to hyperlink to Mantis to see what it
  # filters.
  class FilterData
    include Mantis::XSD::DocBuilder
    attr_accessor :id, :owner, :project_id, :is_public, :name, :filter_string, :url

    # Create a new FilterData Instance
    # @param [Hash] params
    def initialize(params={})
      params.each_key { |p|
        instance_variable_set("@#{p}", params[p])
      }
    end

    # Document will create the ( Nokogiri::XML::Node ) instance for use when
    # constructing a SOAP body request
    # @param [String] tag_name Name of the tag for this XML type
    # (default="filter")
    # @return [Nokogiri::XML::Node]
    def document(tag_name="filter")
      @doc ||= to_doc(tag_name)
    end


    # Construct a ( Nokogiri::XML::Node ) from the attributes in this class
    # @param [String] tag_name Name of the tag to wrap this node in.
    def to_doc(tag_name)
      builder = Nokogiri::XML::Builder.new { |xml|
        xml.send(tag_name, type: "tns:FilterData") do
          xml.id_ @id if @id
          # TODO: Owner (tns:AccountData)
          xml.project_id @project_id if @project_id
          xml.is_public @is_public if @is_public
          xml.name @name if @name
          xml.filter_string @filter_string if @filter_string
          xml.url @url if @url
        end
      }
      builder.doc
    end # to_doc
  end # FilterData
end # Mantis::XSD
