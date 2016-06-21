#!/usr/bin/env ruby
# Copyright Ultragreen (c) 2016
#---
# Author : Romain GEORGES
# type : class definition Ruby
# obj : Generic logging for LightESB
#
#---



# module for Log service
# @author Romain GEORGES <romain@ultragreen.net>
# @see http://www.ultragreen.net/projects/lightesb
# @version 1.0.0
module LightESB
  module Services


    # standard RAA dependency
    require "socket"
    require "bunny"
    
    # class LogFile for providing log capabilities to LightESB
    class LogClient




      
      def initialize( _options = { :source => "LightESB" })
        @source = _options[:source] 
                
        @hostname = Socket.gethostname
        @registry = Carioca::Services::Registry.init :file => Dir.pwd + '/conf/lightesb.registry'
        @configuration = @registry.start_service :name => 'configuration'
        
        @connection = Bunny.new
        @connection.start
        @channel   = @connection.create_channel
        @queue    = @channel.queue(@configuration.settings.esb.base.logs.queue)
        
      end

      def send_log(content)
        @channel.default_exchange.publish(content.to_yaml, :routing_key => @queue.name)
      end

      public

      [:error,:fatal,:warning,:info,:debug].each do |methodname|
        define_method methodname do |message|
          content = {:source => @source, :level => __method__, :message => message, :hostname => @hostname }
          send_log(content)
        end
      end
      
      def garbage
        @connection.close
      end
      

    end
  end
end
