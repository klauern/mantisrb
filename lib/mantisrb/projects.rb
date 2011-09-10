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
      issues_by_project_id(id, page, per_page)
    end

    def issues_by_project_id(id, page=0, per_page=100)
      issues = [] << @session.response_trimmed(:mc_project_get_issues, {
        project_id: id,
        page_number: page,
        per_page: per_page
      })
      issues.map { |issue| Mantis::XSD::IssueData.new issue }
    end

    def issue_headers_by_project_id(id, page=0, per_page=100)
      issues = [] << @session.response_trimmed(:mc_project_get_issue_headers, {
        project_id: id,
        page_number: page,
        per_page: per_page
      })
      issues.map { |issue| Mantis::XSD::IssueHeaderData.new issue }
    end

    def find_by_id(project_id)
      proj_list = list
      proj_list.select { |proj|
        proj[:id].to_i == project_id.to_i # returns an array, but should only be one, so we return the first one
      }[0]
    end

    # Return an Array of project Hashes
    def project_list
      proj_list = @session.response_trimmed :mc_projects_get_user_accessible
      # Savon will wrap an array of arrays of hashes if there's only one
      # project returned from this call.  If so, we need to wrap and create an array
      # with a Hash to be consistent
      prjs = []
      if proj_list[0].class == Array
        prjs += create_project_hash(proj_list) 
      elsif proj_list.class == Array
        prjs += proj_list
      elsif proj_list.class == Hash
        prjs << proj_list
      end
      prjs.map { |prj| Mantis::XSD::ProjectData.new prj }
    end

    # List all accessible projects for this user
    # @return [Array[Hash]] Array of Hashes for each project you can see
    def list
      project_list
      #@session.response_trimmed :mc_projects_get_user_accessible
    end

    # Create a new Project
    # @return [Integer] id of the new Project record in Mantis
    def add(params)
      params = remap_params_for_project_data(params)
      @session.response_trimmed :mc_project_add, 
        Mantis::XSD::ProjectData.new(params).document("project")
    end

    alias :create :add

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

    # Get a list of all categories a project has
    def categories(project_id)
      @session.response_trimmed :mc_project_get_categories, {
        project_id: project_id
      }
    end

    # Add a new category name to an existing project
    def add_category(project_id, name)
      @session.response_trimmed :mc_project_add_category, {
        project_id: project_id,
        p_category_name: name
      }
    end

    # Delete a known category by name from an existing project
    def delete_category(project_id, name)
      @session.response_trimmed :mc_project_delete_category, {
        project_id: project_id,
        p_category_name: name
      }
    end

    # Rename a category in a project, and optionally put it in a new
    # project.
    def rename_category(params)
      hash = rename_category_hash(params)
      @session.response_trimmed :mc_project_rename_category_by_name, hash
    end

    # TODO: Test this with actual custom fields
    def custom_fields_for(id_num)
      @session.response_trimmed :mc_project_get_custom_fields, {
        projec_id: id_num
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
      %w{ status view_state access_min subprojects }.each { |p|
        if (params[p.to_sym])
          stat = @session.config.object_ref_for_value(p.to_sym,params[p.to_sym])
          params[p.to_sym] = stat
        end
      }
      # TODO: Map subprojects
      params
    end


    # Create the correct hash for calling a rename category
    def rename_category_hash(params)
      if params != Hash
        raise <<-ERR
        Parameters not passed in as a Hash
        ERR
      end
      unless params[:project_id] && params[:old_category] &&
             params[:new_category]
        raise <<-ERR
        Did not pass in all necessary parameters.  Need:
          - :project_id
          - :old_category
          - :new_category
          - :project_assigned_to (optional)
        ERR
      end
      hash = {
        project_id: params[:project_id],
        p_category_name: params[:old_category],
        p_category_name_new: params[:new_category],
      }
      hash[:p_assigned_to] = params[:project_assigned_to] if params[:project_assigned_to]
      hash
    end # map_category_hash
  end # Projects
end # Mantis

