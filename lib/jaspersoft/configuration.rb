# lib/jaspersoft/configuration.rb

module Jaspersoft

  module Configuration

    VALID_OPTIONS_KEYS = [:username, :password, :endpoint, :adapter].freeze
    VALID_CONFIG_KEYS = VALID_OPTIONS_KEYS

    DEFAULT_USERNAME = nil
    DEFAULT_PASSWORD = nil
    DEFAULT_ENDPOINT = nil
    DEFAULT_ADAPTER = :net_http

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
    end

    def options
      Hash[ * VALID_CONFIG_KEYS.map { |key| [key, send(key)] }.flatten ]
    end

  end

end