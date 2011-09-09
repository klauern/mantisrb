module Mantis::XSD

  class IssueHeaderData
    include Mantis::XSD::DocBuilder
    attr_reader :id
    attr_accessor :view_state, :last_updated, :project, :category, :priority,
      :severity, :status, :reporter, :summary, :handler, :resolution,
      :attachments_count, :notes_count

    def to_doc(tag_name)
      # TODO: surround conditional
      builder = Nokogiri::XML::Builder.new { |xml|
        xml.send(tag_name, type: "tns:IssueHeaderData") do
          xml.id_ @id if @id
          xml.view_state(type: "tns:ObjectRef") {
            xml.id_ @view_state[:id]
            xml.name @view_state[:name]
          }
          xml.last_updated @last_updated if @last_updated
          xml.project(type: "tns:ObjectRef") {
            xml.id_ @project[:id]
            xml.name @project[:name]
          }
          xml.category @category if @category
          xml.priority(type: "tns:ObjectRef") {
            xml.id_ @priority[:id]
            xml.name @priority[:name]
          }
          xml.severity(type: "tns:ObjectRef") {
            xml.id_ @severity[:id]
            xml.name @priority[:name]
          }
          xml.status(type: "tns:ObjectRef") {
            xml.id_ @status[:id]
            xml.name @status[:name]
          }
          # TODO: reporter (AccountData)
          xml.summary @summary if @build
          # TODO: handler (AccountData)
          xml.resolution(type: "tns:ObjectRef") {
            xml.id_ @resolution[:id]
            xml.name @resolution[:name]
          }
          xml.attachments_count @attachments_count if @attachments_count
          xml.notes_count @notes_count if @notes_count
        end
      }
      builder.doc
    end # to_doc
  end # IssueHeaderData
end # Mantis::XSD
