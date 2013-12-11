module Jaspersoft
  class Client
    module InputControls
      
      # Get a list of all the input controls for a given report
      # 
      # @param reports [String] A path to a report
      # @return [Array<Sawyer::Resource>] An array of input controls resources
      def input_controls(path, params = {}, options = {})
        response = get "#{endpoint_url}/reports/#{normalize_path_slashes(path)}/inputControls/", params, options
        response.inputControl
      end
      
    end
  end
end