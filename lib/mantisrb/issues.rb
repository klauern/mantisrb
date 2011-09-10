module Mantis

  class Issues

    # Create an instnace of Issues.
    # @param [Mantis::Session] Session instance to use for making SOAP requests
    # to Mantis Connect.
    def initialize session
      @session = session
    end

    # Get an issue by the issue id.
    # @param id Issue ID (either {String} or {Integer}) to retrieve
    # @return [IssueData] Issue information
    def by_id(id)
      Mantis::XSD::IssueData.new raw_by_id id
    end

    # Get the raw XML response back from MantisConnect, parsed as a Hash
    # To retrieve a cleaner response, consider using {#by_id}, which will return
    # an instance of {Mantis::XSD::IssueData}
    # @param id issue ID to retrieve
    # @return [Hash] IssueData as a raw Hash object.
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

    def add(params)
      issue_data = map_params_to_issue_data(params)
      @session.response_trimmed :mc_issue_add, issue_data.document("issue")
    end


    alias :create :add

    def update(issue_id, params)
    end

    def delete?(issue_id)
      @session.response_trimmed :mc_issue_delete, {
        issue_id: issue_id
      }
    end

    private

    # User will pass in the name of a param, and this method will retrieve all
    # possible ObjectRef, AccountData, Attachments, Notes, and other types,
    # constructing the proper IssueData class
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

    # Take a Hash of values and create an instance of {IssueData} out of it.
    # If passed an instance of {IssueData} already, return it back.
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
