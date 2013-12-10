require 'sawyer'
require 'base64'
require 'jaspersoft/authentication'
require 'jaspersoft/configuration'
require 'jaspersoft/connection'
require 'jaspersoft/request'
require 'jaspersoft/client/input_controls'
require 'jaspersoft/client/reports'
require 'jaspersoft/client/resources'

module Jaspersoft
  
  class Client
    include Jaspersoft::Configuration
    include Jaspersoft::Connection
    include Jaspersoft::Request
    include Jaspersoft::Authentication
    include Jaspersoft::Client::InputControls
    include Jaspersoft::Client::Reports
    include Jaspersoft::Client::Resources
    
    def initialize(options = {})
      merged_options = Jaspersoft.options.merge(options)

      Configuration::VALID_CONFIG_KEYS.each do |key|
        send("#{key}=", merged_options[key])
      end
      
      login
    end
    
    private
    
    # Formats paths for folders and files
    # 
    # @param path [String] Path to file or folers
    # @option option [Boolean] :leading_slath Prepend a slash
    # @option option [Boolean] :trailing_slath Append a slash
    def normalize_path_slashes(path, options = {})
      options = { leading_slash: false, trailing_slash: false }.merge(options)

      if path != ""
        if options[:leading_slash] == true
          path = "/" + path.to_s if path[0] != "/"
        else
          path = path[1..-1] if path[0] == "/"
        end
        if options[:trailing_slash] == true
          path = path + "/" if path[-1] != "/"
        else
          path = path[0..-2] if path[-1] == "/"
        end
      end

      path
    end

  end

end