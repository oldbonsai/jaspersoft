module Jaspersoft
  class Client
    module Resources
      
      # Get a list of all resources under an optional path path
      #
      # @option options [String] :path The path to search in
      # @option options [Boolean] :recursive Search recursively into subfolders for additional resources. Can be taxing/time consuming if true and searching the root
      # @return [Array<Sawyer::Resource>] Collection of resources available for the provided path
      def resources(path = nil, params = {}, options = {})
        params = { recursive: false }.merge(params)
        params[:folderUri] = normalize_path_slashes path, leading_slash: true, trailing_slash: false if path
        
        response = get "#{endpoint_url}/resources", params, options
        response.resourceLookup
      end
      
    end
  end
end