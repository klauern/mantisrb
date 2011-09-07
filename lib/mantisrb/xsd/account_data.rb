module Mantis::XSD

  class AccountData
    attr_accessor :id, :name, :real_name, :email

    def initialize(params={})
      params.each_key { |p|
        instance_variable_set("@#{p}", params[p])
      }
    end

    def document(tag_name="account")
      @doc ||= to_doc(tag_name)
    end

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

    def to_element_string(tag_name)
      document(tag_name).root.to_s
    end # to_element_string
  end # AccountData
end # Mantis::XSD
