require "bunny"
#require_relative '../application.rb'
require_relative '../sequences/loader.rb'
require 'carioca'

module LightESB
  module Runners

    class LogDispatcher
      def initialize
        @registry = Carioca::Services::Registry.init :file => Dir.pwd + '/conf/lightesb.registry'
        @configuration  = @registry.start_service :name => 'configuration'
        @log = @registry.start_service :name => 'logger'
        @connection = Bunny.new
        @connection.start
        @channel   = @connection.create_channel
        @queue    = @channel.queue(@configuration.settings.esb.base.logs.queue)        
        @map  = @configuration.settings.esb.base.dispatchs.log
        @path = @configuration.settings.esb.base.logs.path
        open_target
      end

      def open_target
        @pool = []
        @map.each do |target|
          @pool.push {:source => target[:from], :logger => @registry.start_service({:name => "log_#{target[:from]}", :params => { :target => "#{@path}/#{target[:to]}" }})
        end
      end
      
      def launch
        begin
          @queue.subscribe(:block => true) do |delivery_info, properties, body|
            content = YAML::load(body)
            message = "#{content[:user]}@#{content[:hostname]}:#{content[:source]} : #{content[:message]}" 
            @pool.select { |x| x[:source] == content[:source]}.each do |log|
              log.send content[:level], message
            end
          end
        rescue Interrupt => _
          @channel.close
          @connection.close
        end
      end
      
    end
    
  end
end






