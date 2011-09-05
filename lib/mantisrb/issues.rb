module Mantis

  class Issues

    def initialize session
      @session = session
    end

    def by_id(id)
      @session.response_trimmed :mc_issue_get, 
        { issue_id: id }
    end

    def exists?(id)
      @session.response_trimmed :mc_issue_exists,
        { issue_id: id }
    end

    def by_summary(issue_summary)
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
      params = remap_params_for_issue_data(params)
      @session.response_trimmed :mc_issue_add,
        Mantis::XSD::IssueData.new(params).document("issue")
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
        project = list.select { |l| l.value? params[:project].to_s}[0]
        params[:project] = project
      end
      params
      #if params[:view_state]
        #view_state = @session.config.view_state_for(params[:view_state])
        #params[:view_state] = view_state
      #end
      #if params[:status]
        #status = @session.config.status_for params[:status]
        #params[:status] = status
      #end
      #if params[:reproducibility]
        #rep = @session.config.reproducibility_for params[:reproducibility]
        #params[:reproducibility] = rep
      #end
    end # remap_params_for_issue_data
  end
end
