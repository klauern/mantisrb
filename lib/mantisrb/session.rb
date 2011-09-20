# Mantis module that is the base for all {::Configs}, {::Session}'s, and
# {::Projects} and {::Filters}
module Mantis

  # A Session is how you will perform requests to Mantis through the SOAP API.
  # 
  # To create a session, simply pass in the URL to the Mantis server, username,
  # and password to use.  The user and pass that you provide will determine
  # what kinds of access you have to Mantis, what kinds of issues you can view,
  # and how you can manipulate or read data.
  #
  # session = Mantis::Session.new("http://mantisserver.com/mantis", "Admin",
  # "Pass")
  #
  # From here, you can use your session to get access to the other parts of the
  # Mantis API, such as Filters, Configs, Issues and Projects.
  class Session
    
    # By default, Mantis ships with MantisConnect at
    # "/api/soap/mantisconnect.php", with the WSDL endpoint being "?wsdl".
    SOAP_API = "/api/soap/mantisconnect.php?wsdl"

    # Create a new Session
    # @param [String] url The base url you would use to access Mantis (not the
    # SOAP endpoint)
    # @param [String] user
    # @param [String] pass
    def initialize(url, user, pass)
      @url = url
      @user = user
      @pass = pass
      @connection = Savon::Client.new do
        wsdl.document = sanitize_api_url(url)
        http.proxy = ENV['http_proxy'] if ENV['http_proxy']
      end
    end

    # Proxy for making requests to Mantis through use of Savon.
    # @param [Symbol] request The Mantis method to be called (such as
    # :mc_version or :mc_enum_status)
    # @param [Hash] params Hash of parameters to pass to SOAP.  These get
    # wrapped into <key>value</key> so nesting is encouraged.
    # @return [Hash] Raw response back from Mantis converted from XML to Hash.
    def response(request, params={})
      @connection.request request do
        soap.body = add_credentials(params)
      end
    end

    # Create a trimmed response from Mantis.  Mantis will generate alot of
    # boilerplate that you have to wade through to get to the actual response.
    # This skips past a couple nestings of less-than-useful XML to get to the
    # raw response.
    # @param [Symbol] request The Request method to call to Mantis.  See the
    # Mantis WSDL for more information on which methods can be passed in
    # @param [Hash] params A Hash of nested values to be converted to a SOAP
    # body request.
    # @return [Hash] Response from Mantis, with a few things trimmed out.
    def response_trimmed(request,params={})
      res = response(request, params)
      unwrap_response(res,request.to_s)
    end

    # Get an instance of the {Mantis::Config} class for use with getting
    # configuration information from Mantis
    # @return [Mantis::Config]
    def config
      @config ||= Config.new self
    end

    # Get the {Mantis::Projects} For use with manipulating and working with
    # Projects in Mantis
    # @return [Mantis::Projects]
    def projects
      @projects ||= Projects.new self
    end

    # Get a {::Filters} instance to get at filters for projects.
    # @return [Mantis::Filters]
    def filters
      @filters ||= Filters.new self
    end

    # Get the {::Issues} instance for manipulating and working with Issues in
    # Mantis
    # @return [Mantis::Issues]
    def issues
      @issues ||= Issues.new self
    end

    # Get the Raw Savon Client
    # @return [Savon::Client]
    def savon_client
      @connection
    end

    private

    # Trim out and try to fix a bad URL if it is passed in incorrectly
    # @param [String] url URL to clean
    # @return [String] A URL that should be just the mantis URL + SOAP endpoint
    def sanitize_api_url(url)
      unless url.match(/\/api\//) 
        return url + SOAP_API
      end
      url
    end

    # Add credential information to a SOAP body.  You can use either a {Hash}
    # or {Nokogiri::XML::Document} to add credentials to.  For whichever you
    # use, you will get the same type back for.
    # @param [Hash] param Parameters that you want to add the credentials to
    # @param [Nokogiri::XML::Document] param could also be a Nokogiri document
    # @return [Hash] your {#param} instance with the username and password
    # added to the SOAP body.
    # @return [Nokogiri::XML::Document] Also could return a Nokogiri Document
    def add_credentials(param)
      if param.class == Nokogiri::XML::Document
        return add_credentials_to_document(param)
      elsif param.class == Hash
        return add_credentials_to_hash(param)
      else
        raise Error, <<-ERR, param
        Incorrect Type.  Must be either Hash or Nokogiri::XML::Document.
        Passed in as #{param.class}
        ERR
      end
      param
    end

    # Add credentials to a {Nokogiri::XML::Document} instance.  (see
    # #add_credentials) if you want to add your login credentials to a Hash
    # SOAP body.
    # @param [Nokogiri::XML::Document] doc The Nokogiri document that you need
    # to add your username and password credentials to
    # @return [Nokogiri::XML::Document]
    def add_credentials_to_document(doc)
      user = Nokogiri::XML::Node.new "username", doc.root
      user.content = @user
      pass = Nokogiri::XML::Node.new "password", doc.root
      pass.content = @pass
      "#{user.to_s}\n#{pass.to_s}\n#{doc.root}"
    end

    # Add credentials to a plain Ruby {Hash}.
    # @param [Hash] hash
    # @return [Hash]
    def add_credentials_to_hash(hash)
      p = {}
      p[:username] = @user
      p[:password] = @pass
      hash.each_pair { |k,v|
        p[k] = v
      }
      p
    end

    # Tease out the actual SOAP response from the envelope and crud wrapping
    # each SOAP call from Mantis.
    # @param [Hash] response_hash The response hash that you likely received
    # from {#response}
    # @return [Hash] the response from it trimed out.
    def unwrap_response(response_hash, method_called)
      method_called += "_response"
      response = response_hash.body[method_called.to_sym][:return]
      # TODO: need to find out which types have a nested :item {} hash in them
      if response.class == Hash && response[:item]
        return remove_xsi_type(response[:item])
      elsif response.class == Hash && response[:"@xsi:type"]
        return remove_xsi_type(response)
      end
      return response
    end

    # Removes the :"@xsi:type" key that is present in most responses
    # from Mantis Connect.  Unless you need it, this API should be mapping
    # those for you for most use-cases.
    # @param [Hash] hash Hash response from {#response}
    # @return [Hash]
    def remove_xsi_type(hash)
      if hash.class == Array && hash[0].class == Hash
        return hash.map { |h| delete_xsi_type(h) }
      elsif hash.class == Hash
        return delete_xsi_type(hash)
      end
      return hash
    end

    # Delete the XSI type out of a hash
    # @param [Hash] hash
    # @return [Hash]
    def delete_xsi_type(hash)
      hash.delete_if { |k,v| k == :"@xsi:type" }
    end

  end
end
