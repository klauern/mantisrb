module Mantis::XSD

  # Versions that are a part of a Project.  These stay with a project and are
  # not generally transferrable between projects.
  class ProjectVersionData

    include Mantis::XSD::DocBuilder

    attr_accessor :id, :name, :project_id, :date_order, :description,
      :released, :obsolete
    

    # Creates a Nokogiri::XML::Element object out of this class
    # @param [String] tag_name name of the XML element to wrap these attributes
    # in.
    def to_doc(tag_name)
      builder = Nokogiri::XML::Builder.new { |xml|
        xml.send(tag_name, type: "tns:ProjectVersionData") do
          xml.id_ @id unless @id == nil
          xml.name @name unless @name == nil
          xml.project_id @project_id unless @project_id == nil
          xml.date_order @date_order unless @date_order == nil
          xml.description @description unless @description == nil
          xml.released @released unless @released == nil
          xml.obsolete @obsolete unless @obsolete == nil
        end
      }
      builder.doc
    end # to_doc
  end # ProjectData
end # Mantis::XSD
