module Mantis::XSD

  # Attachments that can be inserted into a Project itself (and not limited to
  # an Issue in a Project)
  class ProjectAttachmentData

    include Mantis::XSD::DocBuilder

    attr_accessor :id, :filename, :title, :description, :size,
      :content_type, :date_submitted, :download_url, :user_id
    

    # Creates a Nokogiri::XML::Element object out of this class
    # @param [String] tag_filename
    # @return [Nokogiri::XML::Document]
    def to_doc(tag_filename)
      builder = Nokogiri::XML::Builder.new { |xml|
        xml.send(tag_filename, type: "tns:ProjectAttachmentData") do
          xml.id_ @id unless @id == nil
          xml.filename @name unless @name == nil
          xml.title @project_id unless @project_id == nil
          xml.description @description unless @description == nil
          xml.size @description unless @description == nil
          xml.content_type @description unless @description == nil
          xml.date_submitted @description unless @description == nil
          xml.download_url @description unless @description == nil
          xml.user_id @description unless @description == nil
        end
      }
      builder.doc
    end # to_doc
  end # ProjectData
end # Mantis::XSD
