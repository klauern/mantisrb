require 'rubygems'
require 'bundler/setup'
require 'nokogiri'
require 'builder'
require 'savon'
require 'log4r'
require 'mantisrb/version'
require 'mantisrb/session'
require 'mantisrb/issues'
require 'mantisrb/config'
require 'mantisrb/projects'
require 'mantisrb/filters'

include Log4r

# XSD types that might not be used immediately depending on what you're doing
module Mantis::XSD
  autoload :AccountData,                  'mantisrb/xsd/account_data'
  autoload :AttachmentData,               'mantisrb/xsd/attachment_data'
  autoload :CustomFieldValueForIssueData, 'mantisrb/xsd/custom_field_value_for_issue_data'
  autoload :FilterData,                   'mantisrb/xsd/filter_data'
  autoload :IssueData,                    'mantisrb/xsd/issue_data'
  autoload :IssueHeaderData,              'mantisrb/xsd/issue_header_data'
  autoload :IssueNoteData,                'mantisrb/xsd/issue_note_data'
  autoload :ObjectRef,                    'mantisrb/xsd/object_ref'
  autoload :ProjectData,                  'mantisrb/xsd/project_data'
  autoload :RelationshipData,             'mantisrb/xsd/relationship_data'
  autoload :DocBuilder,                   'mantisrb/xsd/doc_builder'
end
