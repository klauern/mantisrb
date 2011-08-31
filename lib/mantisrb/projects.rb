require 'pp'
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

    def issues_by_project_id(id, page=0, per_page=100)
      @session.response_trimmed :mc_project_get_issues, {
        :project_id => id,
        :page_number => page,
        :per_page => per_page
      }
    end

    # Return an Array of project Hashes
    def project_list
      proj_list = @session.response_trimmed :mc_projects_get_user_accessible
      # Savon will wrap an array of arrays of hashes if there's only one
      # project returned from this call.  If so, we need to wrap and create an array
      # with a Hash to be consistent
      if proj_list[0].class == Array
        proj_l = []
        return proj_l << create_project_hash(proj_list) 
      end
      proj_list
    end

    def list
      @session.response :mc_projects_get_user_accessible
    end

    # Create a new Project
    def create(params)
      if params[:status]
        stat = @session.config.project_status_for params[:status]
        params[:status] = stat
      end
      if params[:view_state]
        state = @session.config.view_state_for params[:view_state]
        params[:view_state] = state
      end
      if params[:access_min]
        access = @session.config.access_min params[:access_min]
        params[:access_min] = access
      end
      unless params[:subprojects]
        params[:subprojects] = {}
      end

      @session.response_trimmed :mc_project_add, 
        Mantis::XSD::ProjectData.new(params).document("project")
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

    # MantisConnect defines a type as 'tns:ObjectRef', which is really
    # just a hash of :id and :name
    def object_ref_for(param, xml)
      xml.id(param[:id])
      xml.name(param[:name])
    end

  end
end

