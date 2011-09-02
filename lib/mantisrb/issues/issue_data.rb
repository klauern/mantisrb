module Mantis::XSD

  class IssueData
    attr_accessor :id, :view_state, :last_updated, :project, :category, 
      :priority, :severity, :status, :reporter, :summary, :version, :build, 
      :platform, :os, :os_build, :reproducibility, :date_submitted, 
      :sponsorship_total, :handler, :projection, :eta, :resolution, 
      :fixed_in_version, :target_version, :description, :steps_to_reproduce, 
      :additional_information, :attachments, :relationships, :notes, 
      :custom_fields, :due_date, :monitors

    def initialize(params)
      params.each_key { |p|
        instance_variable_set("@#{p}", params[p])
      }
    end


    def document(tag_name="issue")
      @doc ||= to_doc(tag_name)
    end

    def to_doc(tag_name)
      # TODO: surround conditional 
      builder = Nokogiri::XML::Builder.new { |xml|
        xml.send(tag_name, type: "tns:IssueData") do
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
          xml.version @version if @build
          xml.build @build if @build
          xml.platform @platform if @platform
          xml.os @os if @os
          xml.os_build @os_build if @os_build
          xml.reproducibility(type: "tns:ObjectRef") {
            xml.id_ @reproducibility[:id]
            xml.name @reproducibility[:name]
          }
          xml.date_submitted @date_submitted if @date_submitted
          xml.sponsorship_total @sponsorship_total if @sponsorship_total
          # TODO: handler (AccountData)
          xml.projection(type: "tns:ObjectRef") {
            xml.id_ @projection[:id]
            xml.name @projection[:name]
          }
          xml.eta(type: "tns:ObjectRef") {
            xml.id_ @eta[:id]
            xml.name @eta[:name]
          }
          xml.resolution(type: "tns:ObjectRef") {
            xml.id_ @resolution[:id]
            xml.name @resolution[:name]
          }
          xml.fixed_in_version @fixed_in_version if @fixed_in_version
          xml.target_version @target_version if @target_version
          xml.description @description if @description
          xml.steps_to_reproduce @steps_to_reproduce if @steps_to_reproduce
          xml.additional_information @additional_information if @additional_information
          # TODO: attachments (AttachmentDataArray)
          # TODO: relationships (RelationshipDataArray)
          # TODO: notes (IssueNoteDataArray)
          # TODO: custom_fields (CustomFieldValueForIssueDataArray)
          xml.due_date @due_date if @due_date
          # TODO: monitors (AccountDataArray)
        end
      }
      builder.doc
    end # to_doc

    def to_element_string(tag_name)
      document(tag_name).root.to_s
    end # to_element_string
  end # IssueData
end # Mantis::XSD
