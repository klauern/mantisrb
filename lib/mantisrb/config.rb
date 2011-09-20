module Mantis

  # Configuration information for your Mantis server can be retrieved here.
  class Config

    # Maps an {Mantis::XSD::ObjectRef} instance to a name.
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

    # Create an instance of {Config}
    # @param [Mantis::Session] session Session instance that you have
    # configured to connect to Mantis
    def initialize(session)
      @session = session
    end

    # Retrieve the status types for an issue
    def statuses
      @statuses ||= @session.response_trimmed :mc_enum_status
    end

    # Retrieve the priorities for an issue, such as high, very high, or low
    def priorities
      @priorities ||= @session.response_trimmed :mc_enum_priorities
    end

    # Severities for an issue, such as how important (major, minor)
    def severities
      @severities ||= @session.response_trimmed :mc_enum_severities
    end

    # Reproducibility type of the issue (always, never, N/A, etc.)
    def reproducibilities
      @reproducibilities ||= @session.response_trimmed :mc_enum_reproducibilities
    end

    # Version of Mantis server that you're connecting to
    def version
      @version ||= @session.response_trimmed :mc_version
    end

    # The list of how much work the issue is expected to take to fix (minor,
    # redesign, tweak, etc.)
    def projections
      @projections ||= @session.response_trimmed :mc_enum_projections
    end

    # How long unti the issue is expected or guessed to be completed.
    def etas
      @etas ||= @session.response_trimmed :mc_enum_etas
    end

    # Type of resolution (known error, duplicate, fixed, etc.)
    def resolutions
      @resolutions ||= @session.response_trimmed :mc_enum_resolutions
    end

    # Access level required to manipulate an issue.  ID is usually
    # representative of how much authority you need, thus you might find
    # administrator to be 90 while viewer a mere 10.
    def access_levels
      @access_levels ||= @session.response_trimmed :mc_enum_access_levels
    end

    # Statuses available for a project (stable, development, obsolete, etc.)
    def project_statuses
      @project_states ||= @session.response_trimmed :mc_enum_project_status
    end

    # Visibility of a project (private, public, etc)
    def project_view_states
      @project_view_states ||= @session.response_trimmed :mc_enum_project_view_states
    end

    # Visibility of an issue (public, private)
    def view_states
      @view_states ||= @session.response_trimmed :mc_enum_view_states
    end

    # List of custom field types defined.  Generally, base types such as String
    # and Number are defined here, too
    def custom_field_types
      @custom_field_types ||= @session.response_trimmed :mc_enum_custom_field_types
    end

    # Get a specific enum type (if it isn't something you find elsewhere here.
    # You can also get the same enums that are provided through this API as
    # conveniences
    def enum_get(type)
      @session.response_trimmed :mc_enum_get, {
        enumeration: type
      }
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

