
module Mantis

  class Projects

    def initialize session
      @session = session
    end

    def id_by_name(project_name)
      @session.response :mc_project_get_id_from_name,
        { :project_name => project_name }
    end

    def issues(project_name, page=0, per_page=100)
      id = id_by_name(project_name)
      issues_by_id(id, page, per_page)
    end

    def issues_by_id(id, page=0, per_page=100)
      @session.response :mc_project_get_issues, {
        :project_id => id,
        :page_number => page,
        :per_page => per_page
      }
    end

    def project_list
      @session.response :mc_projects_get_user_accessible
    end

  end
end

