require 'forwardable'
require 'active_support/all'

module LightESB
  module Services
    module Transport
      class Client
        extend ::Forwardable
        def initialize(options = {:provider => 'RabbitMQ'})
          require_relative "../transports/#{options[:provider].downcase}"
          @forward = "LightESB::Transports::#{options[:provider]}::Client".constantize.new
        end
        def_delegators :@forward, :get, :ack, :publish, :close
      end
    end
    
  end
  
end
