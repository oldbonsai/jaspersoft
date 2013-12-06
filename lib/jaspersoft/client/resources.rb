module Jaspersoft
  class Client
    
    module Resources
      
      # Gets resources for specific path, not recursive, but could be
      # Returns resource_descriptor hash generated from response if exists
      def resources(params = {})
        response = get "#{endpoint_url}/resources", params
        response.resourceLookup
      end
      
    end
    
  end
end