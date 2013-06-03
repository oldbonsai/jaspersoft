# lib/jaspersoft/configuration.rb

module Jaspersoft

  module Configuration

    VALID_OPTIONS_KEYS = [:username, :password, :endpoint, :adapter, :report_file_type, :enterprise_server ].freeze
    VALID_CONFIG_KEYS = VALID_OPTIONS_KEYS

    DEFAULT_USERNAME = nil
    DEFAULT_PASSWORD = nil
    DEFAULT_ENDPOINT = nil
    DEFAULT_ADAPTER = :net_http
    DEFAULT_REPORT_FILE_TYPE = :pdf
    DEFAULT_ENTERPRISE_SERVER = false
    # TODO: More config variables

    attr_accessor *VALID_CONFIG_KEYS

    def configure
      yield self
    end

    def self.extended(base)
      base.reset!
    end    

    def reset!
      self.username = DEFAULT_USERNAME
      self.password = DEFAULT_PASSWORD
      self.endpoint = DEFAULT_ENDPOINT
      self.adapter = DEFAULT_ADAPTER
      self.report_file_type = DEFAULT_REPORT_FILE_TYPE
      self.enterprise_server = DEFAULT_ENTERPRISE_SERVER
    end
    
    def options
      Hash[ * VALID_CONFIG_KEYS.map { |key| [key, send(key)] }.flatten ]
    end
    
  end

end