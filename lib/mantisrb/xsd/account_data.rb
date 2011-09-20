module Mantis::XSD

  # AccountData is used to map Account information around.  Users are each
  # given an account and have various properties associated with them.  Any
  # time you need an AccountInformation instance, look to this class.
  class AccountData

    include Mantis::XSD::DocBuilder

    attr_accessor :id, :name, :real_name, :email

    def to_doc(tag_name)
      builder = Nokogiri::XML::Builder.new { |xml|
        xml.send(tag_name, type: "tns:AccountData") do
          xml.id_ @id if @id
          xml.name @name if @name
          xml.real_name @real_name if @real_name
          xml.email @email if @email
        end
      }
      builder.doc
    end # to_doc
  end # AccountData
end # Mantis::XSD
