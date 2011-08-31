module Mantis

  class IssueNote
    attr_accessor :id, :reporter, :text, :view_state, :date_submitted,
      :last_modified, :time_tracking, :note_type, :note_attr


    def initialize(params)
    end
  end
end
