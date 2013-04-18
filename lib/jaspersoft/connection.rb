require "faraday"

module Jaspersoft
  module Connection

    private

    def connection(options)
      default_options = {
        :url => options.fetch(:endpoint, endpoint),
        :adapter => options.fetch(:adapter, adapter)
      }

      @connection ||= Faraday.new(default_options)
    end
  end

end