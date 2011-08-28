require 'mantisrb/config'
require 'mantisrb/projects'

module Mantis

  class Session
    SOAP_API = "/api/soap/mantisconnect.php?wsdl"

    def initialize(url, user, pass)
      @url = url
      @user = user
      @pass = pass
      @connection = Savon::Client.new do
        wsdl.document = sanitize_url(url)
        http.proxy = ENV['http_proxy'] if ENV['http_proxy']
      end
    end

    def response(request, params={})
      conn_response = @connection.request request do
        soap.body = add_credentials(params)
      end
    end

    def response_trimmed(request,params={})
      res = response(request, params)
      unwrap_response(res,request.to_s)
    end

    def config
      @config ||= Config.new @connection
    end

    def projects
      @projects ||= Projects.new @connection
    end

    def savon_client
      @connection
    end

    private

    def sanitize_url(url)
      unless url.match(/\/api\//) 
        return url + SOAP_API
      end
      url
    end

    def add_credentials(param)
      param[:username] = @user
      param[:password] = @pass
      param
    end

    def unwrap_response(response_hash, method_called)
      method_called += "_response"
      response = response_hash.body[method_called.to_sym][:return]
      if response.class == Hash
        return remove_xsi_type(response[:item])
      end
      return response
    end

    # Removes the :"@xsi:type" key that is present in most responses
    # from Mantis Connect.  Unless you need it, this API should be mapping
    # those for you for most use-cases.
    def remove_xsi_type(hash)
      hash.map { |h| h.delete_if { |k,v| k == :"@xsi:type" } } if hash
    end
  end
end
