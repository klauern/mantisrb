module Mantis

  class Issues

    def initialize session
      @session = session
    end

    def by_id(id)
      @session.response :mc_issue_get, { 
        id: id }
    end

    def exists?(id)
      @session.response :mc_issue_exists, {
        issue_id: id
      }
    end

    def by_summary(issue_summary)
      @session.response :mc_issue_get_id_from_summary, {
        summary: issue_summary
      }
    end

    def biggest_id_in_project(project_id)
      @session.response :mc_issue_get_biggest_id, {
        project_id: project_id
      }
    end


    def add(params)
    end

    def update(issue_id, params)
    end

    def delete(issue_id)
      @session.response :mc_issue_delete, {
        issue_id: issue_id
      }
    end


    private

    def create_issue_object(params)

    end
  end
end
