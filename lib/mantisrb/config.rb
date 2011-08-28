module Mantis

  class Config

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

    def access_min(level)
      access_levels.select { |access| access.value? level.to_s }[0] # return first one
    end

    def project_status
      @project_states ||= @session.response_trimmed :mc_enum_project_status
    end

    def project_status_for(status)
      project_status.select { |stat| stat.value? status.to_s }[0] # return first value
    end


    def project_view_states
      @project_view_states ||= @session.response_trimmed :mc_enum_project_view_states
    end

    def view_states
      @view_states ||= @session.response_trimmed :mc_enum_view_states
    end

    def view_state_for(state)
      view_states.select { |s| s.value? state.to_s }[0] # return first value
    end

    def custom_field_types
      @custom_field_types ||= @session.response_trimmed :mc_enum_custom_field_types
    end

  end # Config
end # Mantis

