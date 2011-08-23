module Mantis

  class Config

    def initialize(session)
      @session = session
    end

    def statuses
      $statuses ||= @session.response :mc_enum_status
    end

    def priorities
      $priorities ||= @session.response :mc_enum_priorities
    end

    def severities
      $severities ||= @session.response :mc_enum_severities
    end

    def reproducibilities
      $reproducibilities ||= @session.response :mc_enum_reproducibilities
    end

    def version
      $version ||= @session.response :mc_version
    end

    def projections
      $projections ||= @session.response :mc_enum_projections
    end

    def etas
      $etas ||= @session.response :mc_enum_etas
    end

    def resolutions
      $resolutions ||= @session.response :mc_enum_resolutions
    end

    def access_levels
      $access_levels ||= @session.response :mc_enum_access_levels
    end

    def project_status
      $project_states ||= @session.response :mc_enum_project_status
    end

    def project_view_states
      $project_view_states ||= @session.response :mc_enum_project_view_states
    end

    def view_states
      $view_states ||= @session.response :mc_enum_view_states
    end

    def custom_field_types
      $custom_field_types ||= @session.response :mc_enum_custom_field_types
    end
  end
end

