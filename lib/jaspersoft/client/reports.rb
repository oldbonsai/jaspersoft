module Jaspersoft
  class Client
    module Reports
      
      # Get a list of all reports for the optional path. Note this is can be very taxing because it is recursively checking all subfolders from provided path
      # 
      # @param reports [String] A path to a report folder
      # @option opts [Boolean] :recursive Search the folder recursively
      # @return [Array<Sawyer::Resource>] An array of report resources
      def reports(path = nil, params = {}, options = {})
        params = { recursive: true }.merge(params)
        params[:type] = 'reportUnit'
        
        resources(path, params, options)
      end
      
      # Get a single report object
      # 
      # @param path [String] A full path to a specific report
      # @return [<Sawyer::Resource>] A sinlge report resource
      def report(path, params = {}, options = {})
        params = { content_type: "application/repository.reportUnit+json" }.merge(params)
        
        get "#{endpoint_url}/resources#{normalize_path_slashes(path, leading_slash: true)}", params, options
      end
      alias :find_report :report
      
      # Starts generating a report
      # 
      # @param path [String] A full path to a specific report
      # @option opts [String] :file_type
      # @option opts [Hash] :params A hash of key/value pairs matching with the input controls defined for the report
      # @return [String] A request ID
      def enqueue_report(path, params = {}, options = {})
        params = { file_type: report_file_type.to_s, params: {} }.merge(params)
        params[:outputFormat] = params.delete(:file_type)
        params[:parameters] = convert_report_params params.delete(:params)
        params[:reportUnitUri] = path
        params[:async] = true
        params[:interactive] = false
        
        response = post "#{endpoint_url}/reportExecutions", params, options
        if response && response.requestId
          return response.requestId
        else
          return false # TODO: Error handling
        end
      end
      alias :enqueue :enqueue_report
      
      # Polls the report execution status of a report
      # 
      # @param request_id [String] A report ID, usually in the form of #####-#####-## (with varying digit counts in each group)
      # @return [String] The execution status of the report
      def poll_report(request_id, params = {}, options = {})
        options[:raw_response] = true
        
        response = get "#{endpoint_url}/reportExecutions/#{request_id}/status/", params, options
        if response.status == 200
          return response.data.value
        else
          return "not found"
        end
      end
      alias :poll :poll_report
      
      # Retrieve the formats of a finished report and download the primary format if the report is ready
      # 
      # @param request_id [String] A report ID, usually in the form of #####-#####-## (with varying digit counts in each group)
      # @return [File] Raw binary of the first format available
      def download_report(request_id, params = {}, options = {})
        report_response = get "#{endpoint_url}/reportExecutions/#{request_id}"
        if report_response.status == "ready"
          format = report_response.exports[0].id # TODO: Accept options for which format to grab, verify it's available
          get "#{endpoint_url}/reportExecutions/#{request_id}/exports/#{format}/outputResource"
        else
          return false
        end
      end
      alias :download :download_report
      
      private

      # Convert a normal looking hash into the format that Jaspersoft expects for JSON arguments
      #
      # @param params [Hash] Keys can be either symbols or strings. Values can be an array or a single value.
      # @example
      #   convert_params(school_id: 1234, start_date: "2011-01-01") # => { reportParameter: [ { name: "school_id", value: ["7236"] }, { name: "start_date", value: ["2011-01-01"] } ] }
      def convert_report_params(params)
        converted_params = { reportParameter: [] }
        params.each{ |key, value| converted_params[:reportParameter] << { name: key.to_s, value: (value.is_a? Array) ? value : [ value ] } }
        converted_params
      end
      
    end
    
  end
end