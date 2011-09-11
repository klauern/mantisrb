module Mantis

  class Session
    include Log4r
    SOAP_API = "/api/soap/mantisconnect.php?wsdl"

    def initialize(url, user, pass)
      @logger = Logger.new "mantisrb.log"
      @logger.outputters = Outputter.stdout
      @url = url
      @user = user
      @pass = pass
      @connection = Savon::Client.new do
        wsdl.document = sanitize_api_url(url)
        http.proxy = ENV['http_proxy'] if ENV['http_proxy']
      end
    end

    def response(request, params={})
      @connection.request request do
        soap.body = add_credentials(params)
      end
    end

    def response_trimmed(request,params={})
      res = response(request, params)
      unwrap_response(res,request.to_s)
    end

    def config
      @config ||= Config.new self
    end

    def projects
      @projects ||= Projects.new self
    end

    def filters
      @filters ||= Filters.new self
    end

    def issues
      @issues ||= Issues.new self
    end

    def savon_client
      @connection
    end

    private

    def sanitize_api_url(url)
      unless url.match(/\/api\//) 
        return url + SOAP_API
      end
      url
    end

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

    def add_credentials_to_document(doc)
      user = Nokogiri::XML::Node.new "username", doc.root
      user.content = @user
      pass = Nokogiri::XML::Node.new "password", doc.root
      pass.content = @pass
      "#{user.to_s}\n#{pass.to_s}\n#{doc.root}"
    end

    def add_credentials_to_hash(hash)
      p = {}
      p[:username] = @user
      p[:password] = @pass
      hash.each_pair { |k,v|
        p[k] = v
      }
      p
    end

    def unwrap_response(response_hash, method_called)
      method_called += "_response"
      response = response_hash.body[method_called.to_sym][:return]
      # TODO: need to find out which types have a nested :item {} hash in them
      if response.class == Hash && response[:item]
        @logger.debug "Hash response, with :item"
        return remove_xsi_type(response[:item])
      elsif response.class == Hash && response[:"@xsi:type"]
        @logger.debug "Hash response, with XSI type"
        return remove_xsi_type(response)
      end
      return response
    end

    # Removes the :"@xsi:type" key that is present in most responses
    # from Mantis Connect.  Unless you need it, this API should be mapping
    # those for you for most use-cases.
    def remove_xsi_type(hash)
      if hash.class == Array && hash[0].class == Hash
        return hash.map { |h| delete_xsi_type(h) }
      elsif hash.class == Hash
        return delete_xsi_type(hash)
      end
      return hash
    end

    def delete_xsi_type(hash)
      hash.delete_if { |k,v| k == :"@xsi:type" }
    end

  end
end
