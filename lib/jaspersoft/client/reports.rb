module Jaspersoft
  class Client
    
    module Reports
      
      # Get a list of all reports
      # Note this is can be very taxing because it is recursively checking all subfolders from provided path
      def reports(options = {})
        resources({ type: 'reportUnit', recursive: true }.merge(options))
      end
      
      # Returns report object
      def report(path, options = {})
        get "#{endpoint_url}/resources/#{strip_leading_slash(path)}", { content_type: "application/repository.reportUnit+json" }.merge(options)
      end
      alias :find :report
      
      def input_controls(path, options = {})
        get "#{endpoint_url}/reports/#{strip_leading_slash(path)}/inputControls/", options
      end
      
      # Starts generating a report
      # Returns a request id if successful
      def enqueue_report(path, params = {}, file_type = report_file_type.to_s, options = {})
        options = { reportUnitUri: path, outputFormat: file_type, parameters: params, async: true, interactive: false }.merge(options)
        response = post "#{endpoint_url}/reportExecutions", options
        puts response.inspect
        if response && response.requestId
          puts response.requestId
          return response.requestId
        else
          return false
        end
      end
      alias :enqueue :enqueue_report
      
      # Polls the report execution status of a report
      def poll_report(request_id, options = {})
        response = get "#{endpoint_url}/reportExecutions/#{request_id}/status/", options
        puts response.inspect
        if response && response.value
          return response.value
        else
          return response.inspect
        end
      end
      alias :poll :poll_report
      
      # Retrieve the formats of a finished report and download the primary format if the report is ready
      def download_report(request_id)
        report_response = get "#{endpoint_url}/reportExecutions/#{request_id}"
        if report_response.status == "ready"
          format = report_response.exports[0].id
          get "#{endpoint_url}/reportExecutions/#{request_id}/exports/#{format}/outputResource"
        else
          return false
        end
      end
      alias :download :download_report
      
    end
    
  end
end