module Mantis

  # Issues are the bread and butter of Mantis.  You will need
  # a {Mantis::Session} instance to get at any of this data, since you will
  # need to authenticate against the Mantis API to validate your user's access.
  class Issues

    # Create an instance of Issues.
    # @param [Mantis::Session] Session instance to use for making SOAP requests
    # to Mantis Connect.
    def initialize session
      @session = session
    end

    # Get an issue by the issue id.
    # @param [Integer] id Issue ID (either String or Integer) to retrieve
    # @return [Mantis::XSD::IssueData] or an empty instance of
    # {Mantis::XSD::IssueData} if nothing was returned
    def by_id(id)
      Mantis::XSD::IssueData.new raw_by_id id
    end

    # Get the raw XML response back from MantisConnect, parsed as a Hash
    # To retrieve a cleaner response, consider using {#by_id}, which will return
    # an instance of {Mantis::XSD::IssueData}
    # @param id issue ID to retrieve
    # @return [Hash] {Mantis::XSD::IssueData} as a raw Hash object. (see
    # #by_id) for a more accessible object
    def raw_by_id(id)
      @session.response_trimmed :mc_issue_get, { issue_id: id }
    end

    # Does an Issue exist with the given ID?
    # @param [Integer] id ID to search for
    # @return [Boolean] whether there is an issue with the id or not.
    def exists?(id)
      @session.response_trimmed :mc_issue_exists, { issue_id: id }
    end

    # Search an issue by summary field (Must be explicit).  Use this if you
    # have an exact string to search for, otherwise, consider using {#by_id}
    # instead.
    # @param [String] issue_summary exact issue summary to look for
    # @return [Mantis::XSD::IssueData] Issue if it exists with that particular
    # summary.
    def by_summary(issue_summary)
      Mantis::XSD::IssueData.new raw_by_summary(issue_summary)
    end

    # Same as {#by_summary} except that this returns just a raw Hash instance
    # instead of a full {Mantis::XSD::IssueData} instance.
    # @param [String] issue_summary exact issue summary string
    # @return [Hash] Raw hash of the returned search if it found the issue
    # matching that summmary, otherwise nil.
    def raw_by_summary(issue_summary)
      @session.response_trimmed :mc_issue_get_id_from_summary, {
        summary: issue_summary
      }
    end

    # What is the biggest Issue ID in the project?
    # @param [Integer] project_id ID of the project
    # @return [Integer] biggest integer ID for that project
    def biggest_id_in_project(project_id)
      @session.response_trimmed :mc_issue_get_biggest_id, {
        project_id: project_id
      }
    end

    # Add an issue to a project
    # @param [Mantis::XSD::IssueData] issue instance of
    # {Mantis::XSD::IssueData} to add
    # @return (Boolean) success or failure of attempt to add issue
    def add_with_issue_data(issue)
      @session.response_trimmed :mc_issue_add, issue.document("issue")
    end

    # Add an issue to a project
    # @param [Mantis::XSD::IssueData] params (Mantis::XSD::IssueData) Can be an instance of {Mantis::XSD::IssueData}
    # @param [Hash] params (Hash) Or a hash of values
    # @return [ Boolean ] success or failure of attempt to add issue
    def add(params)
      unless params.class == Mantis::XSD::IssueData
        params = map_params_to_issue_data(params)
      end
      add_with_issue_data(params)
    end

    # @see {#add}
    alias :create :add

    # Update an existing issue, given it's ID
    # You can replace nearly everything in an update, so if you only wnat to
    # change one part of the issue, it would be better to retrieve that
    # {Mantis::XSD::IssueData} instance and make your changes there.
    # @param [Integer] issue_id ID #
    # @param [Hash] params  if it's a hash
    # @param [Mantis::XSD::IssueData] if it's an instance of
    # {Mantis::XSD::IssueData}
    # @return [Boolean] true|false for success or failure of call
    def update?(issue_id, params)
      unless params.class == Mantis::XSD::IssueData
        params = map_params_to_issue_data(params)
      end
      @session.response_trimmed :mc_issue_update, params.document("issue")
    end

    # delete an issue
    # @param [Integer] issue_id id # of issue to delete
    # @return [Boolean] true|false success or failure
    def delete?(issue_id)
      @session.response_trimmed :mc_issue_delete, {
        issue_id: issue_id
      }
    end


    # Mantis has a feature to do a quick check-in on an issue, which allows
    # you to mark an issue as completed or to add a comment to it.
    # @param [Integer] issue_id id of the issue to add a comment for
    # @param [String] comment The comment you'd like to add to this issue
    # @param [Boolean] fixed Whether we can mark this issue as `fixed` or not
    # @return [Boolean] success or failure (true|false)
    def checkin(issue_id, comment, fixed=false)
      @session.response_trimmed :mc_issue_checkin, {
        issue_id: issue_id,
        comment: comment,
        fixed: fixed
      }
    end

    # Add a Note (comment) to an Issue
    # @param [Integer] issue_id
    # @param [Mantis::XSD::IssueNoteData] note_data
    # @return [Integer] the issue_note_id that you created
    def add_note(issue_id, note_data)
      note_data = Mantis::XSD::IssueNoteData.new(note_data) if note_data.class == Hash
      @session.response_trimmmed :mc_issue_note_add, {
        issue_id: issue_id,
        note: note.to_s
      }
    end

    # Delete a note in an issue
    # @param [Integer] issue_note_id id of the note (not issue) to delete
    # @return [Boolean] sucesss/failure of the operation
    def delete_note(issue_note_id)
      @session.response_trimmed :mc_issue_note_delete, {
        issue_note_id: issue_note_id
      }
    end

    # Update a note in an issue
    # @param [Mantis::XSD::IssueNoteData] note Note that you want to update.
    # This note instance should minimally have the ( :id ) identified for it to
    # tie it to a note on Mantis' side.  All other options get overwritten with
    # this data if any of it is different.
    # @return [Boolean] Success or Failure from Mantis
    def update_note(note)
      note = Mantis::XSD::IssueNoteData.new(note) if note.class == Hash
      @session.response_trimmed :mc_issue_note_update, {
        note: note
      }
    end

    # Add a relationship to an issue.
    # @param [Integer] issue id of the issue
    # @param [Mantis::XSD::RelationshipData] relationship Relationship
    # information
    # @return [Integer] id of the relationship
    def add_relationship(issue_id, relationship)
      @session.response_trimmed :mc_issue_relationship_add, {
        issue_id: issue_id,
        relationship: relationship.to_s
      }
    end

    # Delete an issue relationship (can be done from either side of the issue)
    # @param [Integer] issue_id
    # @param [Integer] relationship_id
    # @return [Boolean] succes or failure
    def delete_relationship(issue_id, relationship_id)
      @session.response_trimmed :mc_issue_relationship_delete, {
        issue_id: issue_id,
        relationship_id: relationship_id
      }
    end

    # Add an attachment to an issue
    # @param [Integer] issue_id
    # @param [String] name name of the file
    # @param [String] file_type
    # @param [Base64] data a Base64 encoded binary data representation of the
    # attachment
    # @return [Integer] attachment id to reference
    def add_attachment(issue_id, name, file_type, data)
      @session.response_trimmed :mc_issue_attachment_add, {
        issue_id: issue_id,
        name: name,
        file_type: file_type,
        content: data
      }
    end

    # Delete an attachment
    # @param [Integer] attachment_id
    # @return [Boolean] success or failure
    def delete_attachment(attachment_id)
      @session.response_trimmed :mc_issue_attachment_delete, {
        issue_attachment_id: attachment_id
      }
    end

    # Get an attachment
    # @param [Integer] attachment_id id of the attachment
    # @return [Base64] Base64 encoded data representation of the file
    def get_attachment(attachment_id)
      @session.response_trimmed :mc_issue_attachment_get, {
        issue_attachment_id: attachment_id
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
