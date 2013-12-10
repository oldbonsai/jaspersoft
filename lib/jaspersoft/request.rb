module Jaspersoft
  
  module Request
    
    CONVENIENCE_HEADERS = [ :accept, :content_type ]
    
    def get(path, params = {}, options = {})
      request :get, path, parse_convenience_headers_and_build_query(params), options
    end

    def post(path, params = {}, options = {})
      request :post, path, parse_convenience_headers(params), options
    end

    private

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
    
  end
  
end


