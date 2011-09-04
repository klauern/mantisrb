module Mantis

  class Config

    VALUE_TO_METHOD = { 
      reproducibility: :reproducibilities,
      status: :statuses,
      priority: :priorities,
      severity: :severities,
      projection: :projections,
      eta: :etas,
      resolution: :resolutions,
      access_level: :access_levels,
      access_min: :access_levels,
      project_status: :project_statuses,
      project_view_state: :project_view_states,
      view_state: :view_states,
      custom_field_type: :custom_field_types
    }

    def initialize(session)
      @session = session
    end

    def statuses
      @statuses ||= @session.response_trimmed :mc_enum_status
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

    def project_statuses
      @project_states ||= @session.response_trimmed :mc_enum_project_status
    end

    def project_view_states
      @project_view_states ||= @session.response_trimmed :mc_enum_project_view_states
    end

    def view_states
      @view_states ||= @session.response_trimmed :mc_enum_view_states
    end

    def custom_field_types
      @custom_field_types ||= @session.response_trimmed :mc_enum_custom_field_types
    end

    # instead of writing an individual <some_config_type>_for(value), create
    # a meta-method that will just retrieve the actual ObjectRef for the type
    # and the known value for it.
    def object_ref_for_value(type, value)
      meth = VALUE_TO_METHOD[type]
      if meth
        vals = self.send(meth)
        val = vals.select { |s| s.value? value.to_s }[0]
        raise <<-ERR if val == nil
          No #{type.to_s} known with value #{value}. None found in #{vals}.
          Please ensure that you have entered the correct value for your type.
        ERR
        return val
      else
        raise <<-ERR
          No type, #{type} known.  Be sure it's one of #{VALUE_TO_METHOD.keys}
          ERR
      end
    end
  end # Config
end # Mantis

