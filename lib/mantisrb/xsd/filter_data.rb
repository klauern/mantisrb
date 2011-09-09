module Mantis::XSD

  class FilterData
    include Mantis::XSD::DocBuilder
    attr_accessor :id, :owner, :project_id, :is_public, :name, :filter_string, :url

    def initialize(params={})
      params.each_key { |p|
        instance_variable_set("@#{p}", params[p])
      }
    end

    def document(tag_name="filter")
      @doc ||= to_doc(tag_name)
    end

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

    def to_element_string(tag_name)
      document(tag_name).root.to_s
    end # to_element_string
  end # FilterData
end # Mantis::XSD
