module Mantis::XSD

  class IssueData
    include Mantis::XSD::DocBuilder

    attr_accessor :id, :view_state, :last_updated, :project, :category, 
      :priority, :severity, :status, :reporter, :summary, :version, :build, 
      :platform, :os, :os_build, :reproducibility, :date_submitted, 
      :sponsorship_total, :handler, :projection, :eta, :resolution, 
      :fixed_in_version, :target_version, :description, :steps_to_reproduce, 
      :additional_information, :attachments, :relationships, :notes, 
      :custom_fields, :due_date, :monitors

    def to_s
      to_element_string("issue")
    end

    def to_doc(tag_name)
      builder = Nokogiri::XML::Builder.new { |xml|
        xml.send(tag_name, type: "tns:IssueData") do
          xml.id_ @id if @id
          if (@view_state)
            xml.view_state(type: "tns:ObjectRef") {
              xml.id_ @view_state[:id]
              xml.name @view_state[:name]
            }
          end
          xml.last_updated @last_updated if @last_updated
          if @project
            xml.project(type: "tns:ObjectRef") {
              xml.id_ @project[:id]
              xml.name @project[:name]
            }
          end
          xml.category @category if @category
          if @priority
            xml.priority(type: "tns:ObjectRef") {
              xml.id_ @priority[:id]
              xml.name @priority[:name]
            }
          end
          if @severity
            xml.severity(type: "tns:ObjectRef") {
              xml.id_ @severity[:id]
              xml.name @priority[:name]
            }
          end
          if @status
            xml.status(type: "tns:ObjectRef") {
              xml.id_ @status[:id]
              xml.name @status[:name]
            }
          end
          # TODO: reporter (AccountData)
          xml.summary @summary if @summary
          xml.version @version if @version
          xml.build @build if @build
          xml.platform @platform if @platform
          xml.os @os if @os
          xml.os_build @os_build if @os_build
          if @reproducibility
            xml.reproducibility(type: "tns:ObjectRef") {
              xml.id_ @reproducibility[:id]
              xml.name @reproducibility[:name]
            }
          end
          xml.date_submitted @date_submitted if @date_submitted
          xml.sponsorship_total @sponsorship_total if @sponsorship_total
          # TODO: handler (AccountData)
          if @projection
            xml.projection(type: "tns:ObjectRef") {
              xml.id_ @projection[:id]
              xml.name @projection[:name]
            }
          end
          if @eta
            xml.eta(type: "tns:ObjectRef") {
              xml.id_ @eta[:id]
              xml.name @eta[:name]
            }
          end
          if @resolution
            xml.resolution(type: "tns:ObjectRef") {
              xml.id_ @resolution[:id]
              xml.name @resolution[:name]
            }
          end
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
  end # IssueData
end # Mantis::XSD
