module Mantis

  class IssueData
    attr_accessor :id, :view_state, :last_updated, :project, :category, 
      :priority, :severity, :status, :reporter, :summary, :version, :build, 
      :platform, :os, :os_build, :reproducibility, :date_submitted, 
      :sponsorship_total, :handler, :projection, :eta, :resolution, 
      :fixed_in_version, :target_version, :description, :steps_to_reproduce, 
      :additional_information, :attachments, :relationships, :notes, 
      :custom_fields, :due_date, :monitors

    def initialize(params)
    end

    private

    def object_ref_for(obj)
    end
  end
end
