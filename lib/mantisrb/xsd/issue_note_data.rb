module Mantis::XSD

  class IssueNoteData
    include Mantis::XSD::DocBuilder

    attr_accessor :id, :reporter, :text, :view_state, :date_submitted, :last_modified,
      :time_tracking, :note_type, :note_attr

    #def initialize(params={})
      #params.each_key { |p|
        #instance_variable_set("@#{p}", params[p])
      #}
    #end

    #def document(tag_name="issue_note")
      #@doc ||= to_doc(tag_name)
    #end

    def to_doc(tag_name)
      builder = Nokogiri::XML::Builder.new { |xml|
        xml.send(tag_name, type: "tns:IssueNoteData") do
          xml.id_ @id if @id
          # TODO: reporter (AccountData)
          xml.text @text if @text
          if (@view_state)
            xml.view_state(type: "tns:ObjectRef") {
              xml.id_ @view_state[:id]
              xml.name @view_state[:name]
            }
          end
          xml.date_submitted @date_submitted if @date_submitted
          xml.last_modified @last_modified if @last_modified
          xml.time_tracking @time_tracking if @time_tracking
          xml.note_type @note_type if @note_type
          xml.note_attr @note_attr if @note_attr
        end
      }
      builder.doc
    end # to_doc

    #def to_element_string(tag_name)
      #document(tag_name).root.to_s
    #end # to_element_string
  end # IssueNoteData
end # Mantis::XSD
