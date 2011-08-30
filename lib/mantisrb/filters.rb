module Mantis

  class Filters

    def initialize session
      @session = session
    end

    def get_issues(project_id, page_number=0, per_page=0)
      @session.response :mc_filter_get_issues, {
        project_id: id,
        page_number: page_number,
        per_page: per_page
      }
    end

    def by_project(project_id)
      @session.response :mc_filter_get, {
        project_id: project_id
      }
    end
  end
end
