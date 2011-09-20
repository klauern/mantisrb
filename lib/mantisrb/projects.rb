module Mantis

  # Projects house Issues.
  class Projects

    # You will need a {Mantis::Session} to manipulate projects (based on your
    # user's access).
    # @param [Mantis::Session] session instance of a session that you've
    # created.
    def initialize session
      @session = session
    end

    # Get a project id if you know it's name
    # @param [String] project_name
    # @return [Integer] project id.
    def id_by_name(project_name)
      @session.response_trimmed :mc_project_get_id_from_name,
        { :project_name => project_name }
    end

    # Get the issues for a project (all issues, completed or not)
    # @param [String] project_name Name of the project
    # @param [Integer] page Page Number to load (defaults to first page)
    # @param [Integer] per_page Number of issues to retrieve per page (defaults
    # to 100)
    # @return [Array<Mantis::XSD::IssueData>] Array of {Mantis::XSD::IssueData}
    def issues(project_name, page=0, per_page=100)
      id = id_by_name(project_name)
      issues_by_project_id(id, page, per_page)
    end

    # Get a list of issues by the project id
    # @param [Integer] id
    # @param [Integer] page Page Number to load up (default=0)
    # @param [Integer] per_page Number of issues to load per page (default=100
    # @return [Array<Mantis::XSD::IssueData>]
    def issues_by_project_id(id, page=0, per_page=100)
      issues = @session.response_trimmed(:mc_project_get_issues, {
        project_id: id,
        page_number: page,
        per_page: per_page
      })
      if issues.class == Hash
        return [] << Mantis::XSD::IssueData.new(issues)
      end
      issues.map { |issue| Mantis::XSD::IssueData.new issue }
    end

    # Get An abbreviated listing of issue header information by project id
    # @param [Integer] id
    # @param [Integer] page Page Number to load up (default=0)
    # @param [Integer] per_page Number of issues to load per page (default=100)
    # @return [Array<Mantis::XSD::IssueData>]
    def issue_headers_by_project_id(id, page=0, per_page=100)
      issues = [] << @session.response_trimmed(:mc_project_get_issue_headers, {
        project_id: id,
        page_number: page,
        per_page: per_page
      })
      issues.map { |issue| Mantis::XSD::IssueHeaderData.new issue }
    end

    # Find a project by ID
    # @param [Integer] project_id
    # @return [Mantis::XSD::ProjectData] information about the project
    def find_by_id(project_id)
      proj_list = list
      proj_list.select { |proj|
        proj[:id].to_i == project_id.to_i # returns an array, but should only be one, so we return the first one
      }[0]
    end

    # Get a list of all projects this user can see
    # @return [Array<Mantis::XSD::ProjectData>]
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
    end

    # Get a list of Projects this user can see, as only a Hash of the XML
    # response
    # @return [Hash]
    def project_list_xml
      @session.response(:mc_projects_get_user_accessible).to_xml
    end


    # Create a new Project
    # @return [Integer] id of the new Project record in Mantis
    def add(params)
      params = remap_params_for_project_data(params)
      @session.response_trimmed :mc_project_add, 
        Mantis::XSD::ProjectData.new(params).document("project")
    end

    # {@see add}
    alias :create :add

    # Update an existing project, given the id and the params
    # @param [Hash] params Project Data that you want to update.  Everything in
    # the instance will overwrite what is currently there, so load it before
    # changing it, unless you'd like to change everything.
    # @param [Mantis::XSD::ProjectData] params
    # @return [Boolean] success or failure
    def update?(params)
      params = remap_params_for_project_data(params)
      @session.response_trimmed :mc_project_update,
        Mantis::XSD::ProjectData.new(params).document("project")
    end

    # Remove a project from Mantis with the given @id_num
    # @param [Integer] id_num Project ID
    # @return [Boolean] whether deletion was successful
    def delete?(id_num)
      @session.response_trimmed :mc_project_delete, {
        project_id: id_num
      }
    end

    # Get a list of all categories a project has
    # @param [Integer] project_id
    def categories(project_id)
      @session.response_trimmed :mc_project_get_categories, {
        project_id: project_id
      }
    end

    # Add a new category name to an existing project
    # @param [Integer] project_id
    # @param [String] name Name of the category to create for a Project.
    # @return [Integer] Category ID
    def add_category(project_id, name)
      @session.response_trimmed :mc_project_add_category, {
        project_id: project_id,
        p_category_name: name
      }
    end

    # Delete a known category by name from an existing project
    # @param [Integer] project_id id of the project to delete the category from
    # @param [String] name Name of the category to delete
    # @return [Boolean] success or failure of deletion
    def delete_category(project_id, name)
      @session.response_trimmed :mc_project_delete_category, {
        project_id: project_id,
        p_category_name: name
      }
    end

    # Rename a category in a project, and optionally put it in a new
    # project.
    # @param [Integer] project_id
    # @param [String] category_name_old
    # @param [String] category_name_new
    # @param [Integer] assigned_to ID of the user this category is assigned to
    def rename_category(project_id, category_name_old, category_name_new, assigned_to)
      hash = rename_category_hash(params)
      @session.response_trimmed :mc_project_rename_category_by_name, {
        project_id: project_id,
        p_category_name: category_name_old,
        p_category_name_new: category_name_new,
        p_assigned_to: assigned_to
      }
    end

    # Get a list of custom fields that are configured for this project
    # @param [Integer] id_num Project ID
    # @return [Hash] Hash of custom field types
    def custom_fields_for(id_num)
      @session.response_trimmed :mc_project_get_custom_fields, {
        projec_id: id_num
      }
    end


    # Get a list of versions that this project has
    # @param [Integer] project_id
    # @return [Array<Mantis::XSD::ProjectVersionData>] array of
    # {Mantis::XSD::ProjectVersionData} objects for each version
    def get_versions(project_id)
      @session.response_trimmed :mc_project_get_versions, {
        project_id: project_id
      }
    end

    # Update the version of the project
    # @param [version_id] ID of the *version* of the project, not the project
    # id.
    # @param [Mantis::XSD::ProjectVersionData] project version data instance
    def update_version(version_id, data)
      @session.response_trimmed :mc_project_version_update, {
        version_id: version_id,
        version: data.to_s
      }
    end

    # Delete a version from a project
    # @param [Integer] version_id id of the version instance, not the
    # project_id
    # @return [Boolean] true or false for success
    def delete_version(version_id)
      @session.response_trimmed :mc_project_version_delete, {
        version_id: version_id
      }
    end


    # Get a list of released versions for this project
    # @param [Integer] project_id
    # @return [Array<Mantis::XSD::ProjectVersionData>] array of
    # {Mantis::XSD::ProjectVersionData}
    def get_released_versions(project_id)
      versions_ary = @session.response_trimmed :mc_project_get_released_versions, {
        project_id: project_id
      }
      versions_ary.map { |version| Mantis::XSD::ProjectVersionData.new version }
    end

    # Get the unreleased versions that belong to a project
    # @param [Integer] project_id
    # @return [Array<Mantis::XSD::ProjectVersionData>] array of
    # ProjectVersionData
    def get_unreleased_versions(project_id)
      versions_ary = @session.response_trimmed :mc_project_get_unreleased_versions, {
        project_id: project_id
      }
      versions_ary.map { |version| Mantis::XSD::ProjectVersionData.new version }
    end

    # Get all attachments (information) for a given project
    # @param [Integer] project_id
    # @return [Array<Mantis::XSD::ProjectAttachmentData>] array of project
    # attachment data
    def get_attachments(project_id)
      attachments = @session.response_trimmed :mc_project_get_attachments, {
        project_id: project_id
      }
      attachments.map { |attachment| Mantis::XSD::ProjectAttachmentData.new attachment }
    end

    # Get the data for an attachment for this project
    # @param [Integer] project_attachment_id id of the attachment in the
    # project
    # @return [Base64] Base64 encoded data of the file
    def get_attachment(project_attachment_id)
      @session.response_trimmed :mc_project_attachment_get, {
        project_attachment_id: project_attachment_id
      }
    end

    # Add an attachment to a project
    # @param [Integer] project_id
    # @param [String] name filename
    # @param [String] title Descriptive Title for the file
    # @param [String] description
    # @param [String] file_type
    # @param [Base64] content Base64 encoded data representation
    # @return [Integer] id of the attachment for reference later
    def add_attachment(project_id, name, title, description, file_type, content)
      @session.response_trimmed :mc_project_attachment_add, {
        project_id: project_id,
        name: name,
        title: title,
        description: description,
        file_type: file_type,
        content: content
      }
    end

    # Delete an attachment for a project
    # @param [Integer] project_attachment_id
    # @return [Boolean] successful deletion or failure
    def delete_attachment(project_attachment_id)
      @session.response_trimmed :mc_project_attachment_delete, {
        project_attachment_id: project_attachment_id
      }
    end

    # Get all Sub Projects in a project
    # @param [Integer] project_id
    # @return [Array<String>] list of projects
    def get_all_subprojects(project_id)
      @session.response_trimmed :mc_project_get_all_subprojects, {
        project_id: project_id
      }
    end

    # Get the value for the specified user preference
    # @param [Integer] project_id
    # @param [String] pref_name name of the preference to get
    # @return [String]
    def get_user_preference(project_id, pref_name)
      @session.response_trimmed :mc_user_pref_get_pref, {
        project_id: project_id,
        pref_name: pref_name
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
    # @param [Hash] parameters to rename category for
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
