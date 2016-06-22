require_relative './connector.rb'

module LightESB
  module Connectors
    class MQ < Connector
      def initialize(options = {})
        @body = options[:body]
        super(options)
      end
      
      def consume
        init_sequence(@body)
        return 'ok'
      end
    end
  end
end
