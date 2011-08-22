require "mantisrb/version"
require 'savon'

class MantisConnect


  def initialize(url, user, pass)
    @url = url
    @user = user
    @pass = pass
    @connection = Savon::Client.new do
      wsdl.document = url
      http.proxy ||= ENV['http_proxy']
    end
  end

  def response(request)
    method = request.to_s
    conn_response = @connection.request request
    method += "_response"
    response = conn_response.body[method.to_sym][:return]
    if response[:item]
      return response[:item]
    end
    response
  end


end

