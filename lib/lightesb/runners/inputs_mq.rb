require "bunny"
require_relative '../sequences/loader.rb'
require 'carioca'

module LightESB
  module Runners

    class InputsMQ
      def initialize
        @registry = Carioca::Services::Registry.init :file => Dir.pwd + '/conf/lightesb.registry'
        @configuration  = @registry.start_service :name => 'configuration'
        @log = @registry.start_service :name => 'logclient', :params => { :source => self.class.to_s }
        @connection = Bunny.new
        @connection.start
        @channel   = @connection.create_channel
        @queues = [{:name => 'test', :sequence => 'test'},{:name => 'testy', :sequence => 'qsdqsd'}]
        @queues.each  do |queue|
          queue[:queue]= @channel.queue(queue[:name])        
        end
        end
      
      def launch
        @log.info " [*] Preparing MQ Inputs}."
        begin
          @queues.each do |queue|
            queue[:queue].subscribe(:block => false) do |delivery_info, properties, body|
              @log.info queue[:name]
              @log.info " [x] Received input for sequence #{queue[:sequence]} : forwarding"
            end
          end
          loop do
            sleep 10
          end
        end
        
        rescue Interrupt => _
          @log.info " [END]  unsuscribe #{@queue.name}."
          @channel.close
          @connection.close
        end
      end
    
  end
  
end
