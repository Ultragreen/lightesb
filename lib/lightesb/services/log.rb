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
    require 'time'
    require "socket"
    require 'logger'
    
    # class LogFile for providing log capabilities to LightESB
    class Log

      def initialize( _options = { :target => '/tmp/log.file' , :source => 'main' } )
        @agent_name = _options[:source] 
        @hostname = Socket.gethostname
        @log_file = _options[:targe]
        verif_path File.dirname(@log_file)
        @registry = Carioca::Services::Registry.init :file => Dir.pwd + '/conf/lightesb.registry'
        @configuration = @registry.start_service :name => 'configuration'
        
        @log = Logger::new
        @log.formatter =  proc do |severity, datetime, progname, msg|
          "@#{@hostname} :\t#{datetime}: \t#{severity} \t #{progname}:\t#{msg}\n"
        end
      end

      public

      [:error,:fatal,:warning,:info,:debug].each do |methodname|
        define_method methodname do |message|
          @log.send __method__ , @agent_name, { _message }
        end
      end

      def garbage
      
      end
      
      
      private

      def verif_path(path)
        system("mkdir -p #{path}") unless File::exist?(path)
      end
    end
  end
end
