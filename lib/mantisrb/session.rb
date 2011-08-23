require 'mantisrb/config'

module Mantis

  class Session
    SOAP_API = "/api/soap/mantisconnect.php?wsdl"

    def initialize(url, user, pass)
      @url = url
      @user = user
      @pass = pass
      @connection = Savon::Client.new do
        wsdl.document = sanitize_url(url)
        http.proxy ||= ENV['http_proxy']
      end
    end

    def response(request, params={})
      method = request.to_s
      conn_response = @connection.request request do
        soap.body = add_credentials(params)
      end
      unwrap_response(conn_response, method)
    end

    def project_by_id(id)
      Project.new session, id
    end

    def config
      @config ||= Config.new @connection
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
        return response[:item]
      end
      return response
    end

  end
end
