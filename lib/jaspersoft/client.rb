# lib/jaspersoft/client.rb
require 'jaspersoft/connection'
require 'jaspersoft/request'
require 'active_support/core_ext/hash/conversions'
require 'nokogiri'
require 'base64'

module Jaspersoft
  
  class Client
    include Jaspersoft::Connection
    include Jaspersoft::Request

    attr_accessor *Configuration::VALID_CONFIG_KEYS

    def initialize(options={})
      merged_options = Jaspersoft.options.merge(options)

      Configuration::VALID_CONFIG_KEYS.each do |key|
        send("#{key}=", merged_options[key])
      end
    end
    
    def username=(username)
      @username = username
      encode_authorization
      @username
    end

    def password=(password)
      @password = password
      encode_authorization
      @password
    end

    # Gets resources for specific path, not recursive, but could be
    # Returns resource_descriptor hash generated from response if exists
    def get_resources(path='', params={})
      response = get("#{endpoint_url}/rest/resources/#{check_and_fix_path(path)}", params, {authorization: @authorization})
      nokogiri_reponse = Nokogiri::XML(response)
      hash = Hash.from_xml(nokogiri_reponse.to_s)
      (hash and hash['resourceDescriptors']) ? hash['resourceDescriptors']['resourceDescriptor'] : nil
    end

    # Get a list of all reports
    # Note this is can be very taxing because it is recursively checking all subfolders from provided path
    def get_reports(path='', params={})
      params = {type: 'reportUnit', recursive: 1}.merge(params)
      reports = get_resources(path, params)
    end

    # Returns raw data for report based on file_type
    # Not sure what happens on incorrect path/report
    def run_report(path, params={}, file_type=report_file_type)
      response = get("#{endpoint_url}/rest_v2/reports/#{check_and_fix_path(path)}.#{file_type}", params, {authorization: @authorization})
    end

    # JasperReports Server Web Services Guide: 3.3.1
    # Returns Input Control JSON object if exists? else nil
    def get_report_input_controls(path, params={})
      response = get("#{endpoint_url}/rest_v2/reports/#{check_and_fix_path(path)}/inputControls", params, {authorization: @authorization, accept: "application/json"})
      ActiveSupport::JSON.decode(response)["inputControl"] unless response.nil?
    end
    
    private

    def encode_authorization
      @authorization = "Basic #{::Base64.strict_encode64("#{self.username}:#{self.password}")}"
    end
    
    def endpoint_url
      "#{endpoint}/jasperserver#{enterprise_server ? "-pro" : ""}"
    end

    # Prunes off leading '/' if the slash exists
    def check_and_fix_path(path)
      path = path[1..-1] if path[0] == "/"
      path
    end

  end

end