require_relative './connector.rb'
require_relative '../../application.rb'

module LightESB
  module Connectors
    class HTTP < Connector
      def initialize(options = {})
        @body = options[:body]
        @application = Application.get
        super(options)
      end
      
      def consume
        init_sequence(@body)
        return 'ok'
      end
    end
  end
end
