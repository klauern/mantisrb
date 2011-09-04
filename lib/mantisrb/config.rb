module Mantis

  class Config

    def initialize(session)
      @session = session
    end

    def statuses
      @statuses ||= @session.response_trimmed :mc_enum_status
    end

    def status_for(status)
      s = statuses.select { |stat| stat.value? status.to_s }[0] # return first value
      raise <<-ERR if s == nil
        No status \"#{status}\" matched list of issue status types.
        Please ensure that you typed the correct status.
      ERR
      s
    end

    def priorities
      @priorities ||= @session.response_trimmed :mc_enum_priorities
    end

    def severities
      @severities ||= @session.response_trimmed :mc_enum_severities
    end

    def reproducibilities
      @reproducibilities ||= @session.response_trimmed :mc_enum_reproducibilities
    end

    def reproducibility_for(reproducibility)
      r = reproducibilities.select { |stat| stat.value? reproducibility.to_s }[0] # return first value
      raise <<-ERR if r == nil
        No status \"#{status}\" matched list of reproducibilities.
        Please ensure that you typed the correct type.
      ERR
      r
    end

    def version
      @version ||= @session.response_trimmed :mc_version
    end

    def projections
      @projections ||= @session.response_trimmed :mc_enum_projections
    end

    def etas
      @etas ||= @session.response_trimmed :mc_enum_etas
    end

    def resolutions
      @resolutions ||= @session.response_trimmed :mc_enum_resolutions
    end

    def access_levels
      @access_levels ||= @session.response_trimmed :mc_enum_access_levels
    end

    def access_min(level)
      a = access_levels.select { |access| access.value? level.to_s }[0] # return first one
      raise <<-ERR if a == nil
        No access level \"#{level}\" matched possible levels: #{access_levels}
        Please try again with one of the above
        ERR
        a
    end

    def project_statuses
      @project_states ||= @session.response_trimmed :mc_enum_project_status
    end

    def project_status_for(status)
      s = project_statuses.select { |stat| stat.value? status.to_s }[0] # return first value
      raise <<-ERR if s == nil
        No status \"#{status}\" matched list of project status types.
        Please ensure that you typed the correct status.
      ERR
      s
    end

    def project_view_states
      @project_view_states ||= @session.response_trimmed :mc_enum_project_view_states
    end

    def view_states
      @view_states ||= @session.response_trimmed :mc_enum_view_states
    end

    def view_state_for(state)
      v = view_states.select { |s| s.value? state.to_s }[0] # return first value
      raise <<-ERR if v == nil
        No view state for \"#{state}\" found in list: #{view_states}
        Please try one of the above
      ERR
      v
    end

    def custom_field_types
      @custom_field_types ||= @session.response_trimmed :mc_enum_custom_field_types
    end

    # instead of writing an individual <some_config_type>_for(type), create
    # a meta-method that will just retrieve the actual ObjectRef for the type
    # and the known value for it.
    # TODO: Not tested at all.  Fix that.
    def map_value_to_object_ref_for(type, value)
      VALUE_TO_METHOD = { 
        reproducibility: :reproducibilities,
        status: :statuses,
        priority: :priorities,
        severity: :severities,
        projection: :projections,
        eta: :etas,
        resolution: :resolutions,
        access_level: :access_levels,
        access_min: :access_min,
        project_status: :project_statuses,
        view_state: :view_states,
        custom_field_type: :custom_field_types
      }
      meth = VALUE_TO_METHOD[type]
      if meth
        vals = self.send(meth)
        val = vals.select { |s| s.value? value.to_s }[0]
        raise <<-ERR if val == nil
          No #{type.to_s} known with value #{value}. None found in #{vals}.
          Please ensure that you have entered the correct value for your type.
        ERR
        return v
      else
        raise <<-ERR
          No type, #{type} known.  Be sure it's one of #{VALUE_TO_METHOD.keys}
        ERR
      end
    end

  end # Config
end # Mantis

