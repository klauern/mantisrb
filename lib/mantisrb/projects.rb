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
        project_id: id,
        page_number: page,
        per_page: per_page
      }
    end

    # Return an Array of project Hashes
    def project_list
      proj_list = @session.response_trimmed :mc_projects_get_user_accessible
      # Savon will wrap an array of arrays of hashes if there's only one
      # project returned from this call.  If so, we need to wrap and create an array
      # with a Hash to be consistent
      if proj_list[0].class == Array
        return [] << create_project_hash(proj_list) 
      end
      proj_list
    end

    # List all accessible projects for this user
    # @return [Array[Hash]] Array of Hashes for each project you can see
    def list
      @session.response_trimmed :mc_projects_get_user_accessible
    end

    # Create a new Project
    # @return [Integer] id of the new Project record in Mantis
    def create(params)
      params = remap_params_for_project_data(params)
      @session.response_trimmed :mc_project_add, 
        Mantis::XSD::ProjectData.new(params).document("project")
    end

    # Update an existing project, given the id and the params
    def update?(params)
      params = remap_params_for_project_data(params)
      @session.response_trimmed :mc_project_update,
        Mantis::XSD::ProjectData.new(params).document("project")
    end

    # Remove a project from Mantis with the given @id_num
    # @return [Boolean] whether deletion was successful
    def delete?(id_num)
      @session.response_trimmed :mc_project_delete, {
        project_id: id_num
      }
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

    # User will pass in the name of the param, and this method
    # will retrieve the correct ObjectRef from Mantis that corresponds
    # to the name, with id.
    def remap_params_for_project_data(params)
      if params[:status]
        stat = @session.config.project_status_for params[:status]
        #binding.pry
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
      if params[:subprojects]
        raise 'Subprojects are unsupported at this time'
        # TODO: Map subprojects
        #params[:subprojects] = {}
      end
      params
    end

  end
end

