require "bunny"
#require_relative '../application.rb'
require_relative '../sequences/loader.rb'
require 'carioca'

module LightESB
  module Runners

    class MQ
      def initialize
        @registry = Carioca::Services::Registry.init :file => Dir.pwd + '/conf/lightesb.registry'
        @configuration  = @registry.start_service :name => 'configuration'
        @log = @registry.start_service :name => 'logclient'
        @connection = Bunny.new
        @connection.start
        @channel   = @connection.create_channel
        @queue    = @channel.queue("lightesb.sequences.inputs")        
      end
      
      def launch
        @log.info " [*] Waiting for messages in #{@queue.name}."
        begin
          @queue.subscribe(:block => true) do |delivery_info, properties, body|
            content = YAML::load(body)
            @log.info " [x] Received message for sequence #{content[:sequence]} : #{content[:id]}"
            seq = @configuration.settings[:esb][:sequences][:sequence].select {|item| item[:name] == content[:sequence] }.first
            sequence = LightESB::Sequences::Loader::new({:hash => seq, :id => content[:id], :name => content[:sequence]}).sequence
            sequence.execute
          end
        rescue Interrupt => _
          @log.info " [END]  unsuscribe #{@queue.name}."
          @channel.close
          @connection.close
        end
      end
      
    end
    
  end
end
