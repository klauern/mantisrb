module Mantis::XSD

  class ProjectData
    attr_accessor :name, :status, :enabled, :view_state, :inherit_global
    attr_accessor :access_min, :file_path, :description, :subprojects
    attr_reader :id

    def initialize(params)
    end

    # Creates a Nokogiri::XML::Element object out of this class
    def to_element(tag_name)
      builder = Nokogiri::XML::Builder.new { |xml|
        xml.id_ @id
        xml.name @name
        xml.status(type: "tns:ObjectRef") {
          xml.id_ @status.id
          xml.name @status.name
        }
        xml.enabled @enabled
        xml.view_state(type: "tns:ObjectRef") {
          xml.id_ @view_state.id
          xml.name @view_state.name
        }
        xml.access_min(type: "tns:ObjectRef") {
          xml.id_ @access_min.id
          xml.name @access_min.name
        }
        xml.file_path @file_path
        xml.description @description
        xml.subprojects(type: "tns:ProjectDataArray") {
          # TODO: figure this one out, get Array of ProjectData
        }
        xml.inherit_global @inherit_global
      }
      builder.doc.root
    end # to_element
  end # ProjectData
end # Mantis::XSD

