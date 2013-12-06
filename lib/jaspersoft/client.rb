require 'sawyer'
require 'base64'
require 'jaspersoft/connection'
require 'jaspersoft/request'
require 'jaspersoft/client/reports'
require 'jaspersoft/client/resources'

module Jaspersoft
  
  class Client
    include Jaspersoft::Configuration
    include Jaspersoft::Client::Reports
    include Jaspersoft::Client::Resources
    
    CONVENIENCE_HEADERS = [ :accept, :content_type ]
    
    def initialize(options = {})
      merged_options = Jaspersoft.options.merge(options)

      Configuration::VALID_CONFIG_KEYS.each do |key|
        send("#{key}=", merged_options[key])
      end
      
      login
    end
    
    def get(path, params = {}, options = {})
      request :get, path, parse_convenience_headers_and_build_query(params), options
    end

    def post(path, params = {}, options = {})
      request :post, path, parse_convenience_headers(params), options
    end
    
    def login
      response = post "#{ endpoint_url(v2: false) }/login/", { content_type: "application/x-www-form-urlencoded", j_username: username, j_password: password }, { raw_response: true }
      if response && response.status == 200 && response.headers["set-cookie"] != ""
        session_id = response.headers["set-cookie"].match(/jsessionid=(.+?);/i)[1]
        @cookie = "$Version=0; JSESSIONID=#{session_id}; $Path=/jasperserver"
        @agent = fresh_agent
      else
        raise AuthenticationError
      end
    end
    
    def agent
      @agent ||= fresh_agent
    end

    # JasperReports Server Web Services Guide: 3.3.1
    # Returns Input Control JSON object if exists? else nil
    def get_report_input_controls(path, params={})
      response = get("#{endpoint_url}/reports/#{check_and_fix_path(path)}/inputControls", params, {authorization: @authorization, accept: "application/json"})
      # ActiveSupport::JSON.decode(response)["inputControl"] unless response.nil?
    end
    
    def endpoint_url(options = {})
      options = { v2: true }.merge(options)
      "#{ endpoint }/jasperserver#{ enterprise_server ? "-pro" : "" }/rest#{ "_v2" if options[:v2] }"
    end
    
    def last_response
      @last_response
    end
    
    private
    
    def fresh_agent
      Sawyer::Agent.new(endpoint, sawyer_options) do |http|
        if @cookie
          http.headers[:Cookie] = @cookie
        else
          http.basic_auth(username, password)
        end
      end
    end
    
    def request(method, path, params, options = {})
      if params.is_a?(Hash)
        options[:query]   = params.delete(:query) || {}
        options[:headers] = params.delete(:headers) || {}
        if accept = params.delete(:accept)
          options[:headers][:accept] = accept
        end
      end
      @last_response = response = agent.call(method, URI.encode(path.to_s), params, options)
      (options[:raw_response]) ? response : response.data
    end
    
    def sawyer_options
      opts = {
        :links_parser => Sawyer::LinkParsers::Simple.new
      }
      conn_opts = @connection_options
      conn_opts[:builder] = @middleware if @middleware
      conn_opts[:proxy] = @proxy if @proxy
      opts[:faraday] = Faraday.new(conn_opts)

      opts
    end

    def parse_convenience_headers(params)
      headers = params.fetch(:headers, { accept: media_type, content_type: media_type, user_agent: user_agent })
      CONVENIENCE_HEADERS.each do |h|
        if header = params.delete(h.to_sym)
          headers[h] = header
        end
      end
      params[:headers] = headers
      params
    end
    
    def build_query(params)
      query = params.delete(:query)
      headers = params.delete(:headers)
      
      _params = { query: params, headers: headers }
      _params[:query].merge!(query) if query && query.is_a?(Hash)
      _params
    end
    
    def parse_convenience_headers_and_build_query(params)
      _params = parse_convenience_headers(params)
      _params = build_query(_params)
      _params
    end
    
    # Prunes off leading '/' if the slash exists
    def strip_leading_slash(path)
      path = path[1..-1] if path[0] == "/"
      path
    end

  end

end