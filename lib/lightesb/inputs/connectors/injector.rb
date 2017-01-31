require_relative './connector.rb'

module LightESB
  module Connectors
    class Injector < Connector
      def initialize(options = {})
        @payload = options[:payload]
        @job = options[:job]
        super(options)
      end
      
      def send
        @log.info " [>] Sending sequence #{@sequence} for #{@job}"
        init_sequence(@payload)
      end
    end
  end
end

