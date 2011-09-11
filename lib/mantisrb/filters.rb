module Mantis

  class Filters

    def initialize session
      @session = session
    end

    def by_project(project_id)
      filters = [] << @session.response_trimmed(:mc_filter_get, {
        project_id: project_id
      })
      filters.map { |f| Mantis::XSD::FilterData.new f }
    end

    alias :list :by_project

    def raw_issues_for(project_id, filter_id, page_num=0, per_page=50)
      @session.response_trimmed :mc_filter_get_issues, {
        project_id: project_id,
        filter_id: filter_id,
        page_number: page_num,
        per_page: per_page
      }
    end

    def issues_for(project_id, filter_id, page_num=0, per_page=50)
      raw = raw_issues_for(project_id, filter_id, page_num, per_page)
      issues = raw.map { |issue| Mantis::XSD::IssueData.new issue }
    end
  end # Filters
end # Mantis
