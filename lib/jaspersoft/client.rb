# lib/jaspersoft/client.rb

module Jaspersoft
  
  class Client
    attr_accessor *Configuration::VALID_CONFIG_KEYS

    def initialize(options={})
      merged_options = Jaspersoft.options.merge(options)

      Configuration::VALID_CONFIG_KEYS.each do |key|
        send("#{key}=", merged_options[key])
      end
    end

    def login(options)
      params = prepare_request_params(options)

    end

    private

    def prepare_request_params(options)
      
    end

  end

end