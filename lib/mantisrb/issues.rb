module Mantis

  class Issues

    # Create an instnace of Issues.
    # @param [Mantis::Session] Session instance to use for making SOAP requests
    # to Mantis Connect.
    def initialize session
      @session = session
    end

    # Get an issue by the issue id.
    # @param id Issue ID (either String or Integer) to retrieve
    # @return [Mantis::XSD::IssueData] Issue information
    def by_id(id)
      Mantis::XSD::IssueData.new raw_by_id id
    end

    # Get the raw XML response back from MantisConnect, parsed as a Hash
    # To retrieve a cleaner response, consider using {#by_id}, which will return
    # an instance of {Mantis::XSD::IssueData}
    # @param id issue ID to retrieve
    # @return [Hash] {Mantis::XSD::IssueData} as a raw Hash object.
    def raw_by_id(id)
      @session.response_trimmed :mc_issue_get, { issue_id: id }
    end

    # Does an Issue exist with the given ID?
    # @param id ID to search for
    # @return [Boolean] whether there is an issue with the id or not.
    def exists?(id)
      @session.response_trimmed :mc_issue_exists, { issue_id: id }
    end

    # Search an issue by summary field (Must be explicit).  Use this if you
    # have an exact string to search for, otherwise, consider using {#by_id}
    # instead.
    def by_summary(issue_summary)
      Mantis::XSD::IssueData.new raw_by_summary(issue_summary)
    end

    def raw_by_summary(issue_summary)
      @session.response_trimmed :mc_issue_get_id_from_summary, {
        summary: issue_summary
      }
    end

    def biggest_id_in_project(project_id)
      @session.response_trimmed :mc_issue_get_biggest_id, {
        project_id: project_id
      }
    end

    # Add an issue to a project
    # @param issue (Mantis::XSD::IssueData) Instance of {Mantis::XSD::IssueData} to use
    # @return (Boolean) success or failure of attempt to add issue
    def add_with_issue_data(issue)
      @session.response_trimmed :mc_issue_add, issue.document("issue")
    end

    # Add an issue to a project
    # @param params (Mantis::XSD::IssueData) Can be an instance of {Mantis::XSD::IssueData}
    # @param params (Hash) Or a hash of values
    # @return (Boolean) success or failure of attempt to add issue
    def add(params)
      unless params.class == Mantis::XSD::IssueData
        params = map_params_to_issue_data(params)
      end
      add_with_issue_data(params)
    end

    alias :create :add

    # Update an existing issue, given it's ID
    # You can replace nearly everything in an update, so if you only wnat to
    # change one part of the issue, it would be better to retrieve that
    # {Mantis::XSD::IssueData} instance and make your changes there.
    # @param issue_id ID #
    # @param params 
    # @return true|false for success or failure of call
    def update?(issue_id, params)
      unless params.class == Mantis::XSD::IssueData
        params = map_params_to_issue_data(params)
      end
      @session.response_trimmed :mc_issue_update, params.document("issue")
    end

    # delete an issue
    # @param issue_id id # of issue to delete
    # @return true|false success or failure
    def delete?(issue_id)
      @session.response_trimmed :mc_issue_delete, {
        issue_id: issue_id
      }
    end


    # Mantis has a feature to do a quick check-in on an issue, which allows
    # you to mark an issue as completed or to add a comment to it.
    def checkin(issue_id, comment, fixed=false)
      @session.response_trimmed :mc_issue_checkin, {
        issue_id: issue_id,
        comment: comment,
        fixed: fixed
      }
    end

    def add_note(issue_id, note_data)
      @session.response_trimmmed :mc_issue_note_add, {
        issue_id: issue_id,
        note: note_data.to_s
      }
    end

    def delete_note(issue_note_id)
      @session.response_trimmed :mc_issue_note_delete, {
        issue_note_id: issue_note_id
      }
    end

    def update_note(note)
      @session.response_trimmed :mc_issue_note_update, {
        note: note
      }
    end

    private

    # User will pass in the name of a param, and this method will retrieve all
    # possible ObjectRef, AccountData, Attachments, Notes, and other types,
    # constructing the proper {Mantis::XSD::IssueData} class
    def remap_params_for_issue_data(params)
      %w{ view_state status reproducibility }.each { |parm|
        if(params[parm.to_sym])
          val = @session.config.object_ref_for_value(parm, params[parm.to_sym])
          params[parm.to_sym] = val
        end
      }
      if params[:project]
        list = @session.projects.list
        # this allows both an id and a name to be passed in, since it's looking
        # at all values to match EXACTLY the value passed in.
        project = list.select { |l| l.id == params[:project].to_s}[0]
        params[:project] = project
      end
      params
    end # remap_params_for_issue_data

    # Take a Hash of values and create an instance of {Mantis::XSD::IssueData} out of it.
    # If passed an instance of {Mantis::XSD::IssueData} already, return it back.
    def map_params_to_issue_data(params)
      if params.class == Mantis::XSD::IssueData
        return params
      elsif params.class == Hash
        return Mantis::XSD::IssueData.new(remap_params_for_issue_data(params))
      end
      raise "Wrong Type passed in.  Must be either a Hash of parameters or IssueData instance"
    end # map_params_to_issue_data
  end
end
