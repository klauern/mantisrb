module Mantis::XSD

  class ProjectData
    attr_accessor :name, :status, :enabled, :view_state, :inherit_global
    attr_accessor :access_min, :file_path, :description, :subprojects
    attr_reader :id

    def initialize(params)
      params.each_key { |p|
        instance_variable_set("@#{p}", params[p])
      }
    end

    def document(tag_name=nil)
      if tag_name
        @doc ||= to_doc(tag_name) 
      else
        @doc ||= to_doc
      end
    end

    # Creates a Nokogiri::XML::Element object out of this class
    def to_doc(tag_name="project")
      builder = Nokogiri::XML::Builder.new { |xml|
        xml.send(tag_name, type: "tns:ProjectData") do
          xml.id_ @id unless @id == nil
          xml.name @name unless @name == nil
          if @status
            xml.status(type: "tns:ObjectRef") {
              xml.id_ @status[:id]
              xml.name @status[:name]
            }
          end
          xml.enabled @enabled unless @enabled == nil
          if @view_state
            xml.view_state(type: "tns:ObjectRef") {
              xml.id_ @view_state[:id]
              xml.name @view_state[:name]
            }
          end
          if @access_min
            xml.access_min(type: "tns:ObjectRef") {
              xml.id_ @access_min[:id]
              xml.name @access_min[:name]
            }
          end
          xml.file_path @file_path unless @file_path == nil
          xml.description @description unless @description == nil
          if @subprojects.size > 0
            puts "There Are Subprojects"
            xml.subprojects(type: "tns:ProjectDataArray") {
              # TODO: figure this one out, get Array of ProjectData
            }
          end
          xml.inherit_global @inherit_global unless @inherit_global == nil
        end
      }
      builder.doc
    end # to_doc

    def to_element_string(tag_name)
      document(tag_name).root.to_s
    end # to_element_string
  end # ProjectData
end # Mantis::XSD

