
module Mantis

  class Projects

    def initialize session
      @session = session
    end

    def id_by_name(project_name)
      @session.response_trimmed :mc_project_get_id_from_name,
        { :project_name => project_name }
    end

    def issues(project_name, page=0, per_page=100)
      id = id_by_name(project_name)
      issues_by_id(id, page, per_page)
    end

    def issues_by_id(id, page=0, per_page=100)
      @session.response_trimmed :mc_project_get_issues, {
        :project_id => id,
        :page_number => page,
        :per_page => per_page
      }
    end

    # Return a Hash of projects, nil otherwise
    def project_list
      proj_list = @session.response_trimmed :mc_projects_get_user_accessible
      create_project_hash(proj_list) if proj_list
    end

    def list
      @session.response :mc_projects_get_user_accessible
    end


    private

    # The SOAP response from MantisConnect is an array of
    # hashes, which makes dealing with it a bit of a nightmare.
    # tease out the pieces and put them in as one hash.
    def create_project_hash(project)
      proj = {}
      project.each { |ary|
        proj[ary[0]] = ary[1]
      }
      proj
    end


  end
end

