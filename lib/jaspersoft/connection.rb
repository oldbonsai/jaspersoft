module Jaspersoft
  
  module Connection
    
    def agent
      @agent ||= new_agent
    end

    def last_response
      @last_response
    end
    
    private
    
    def new_agent(&block)
      Sawyer::Agent.new(endpoint, agent_options, &block)
    end
    
    def agent_options
      opts = {
        :links_parser => Sawyer::LinkParsers::Simple.new
      }
      conn_opts = @connection_options || {}
      conn_opts[:builder] = @middleware if @middleware
      conn_opts[:proxy] = @proxy if @proxy
      opts[:faraday] = Faraday.new(conn_opts)

      opts
    end
    
  end
  
end