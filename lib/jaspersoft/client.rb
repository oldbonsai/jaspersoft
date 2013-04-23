# lib/jaspersoft/client.rb
require 'jaspersoft/connection'
require 'jaspersoft/request'
require 'active_support/core_ext/hash/conversions'
require 'nokogiri'

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

    def login()
      params = {
        'j_username' => self.username,
        'j_password' => self.password
      }
      # TODO: add check for pro version in building url
      response = post("#{self.endpoint}/jasperserver/rest/login", params, {raw: true})
      @auth_cookie = response['set-cookie']#.split(';')[0]

    end

    def get_resources(path='')
      response = get("#{self.endpoint}/jasperserver/rest/resources/#{path}", {}, {auth_cookie: @auth_cookie})
      nokogiri_reponse = Nokogiri::XML(response)
      hash = Hash.from_xml(nokogiri_reponse.to_s)
      hash['resourceDescriptors']['resourceDescriptor']
    end

    def run_report(path, params={})
      response = get("#{self.endpoint}/jasperserver/rest_v2/reports/#{path}", params, {auth_cookie: @auth_cookie})
    end

    private

    def prepare_request_params(options)
      #prepend j_ and password has ? at the end
    end

  end

end