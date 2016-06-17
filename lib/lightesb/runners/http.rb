# coding: utf-8
require 'sinatra/base'
require_relative '../inputs/connectors/http.rb'
require_relative '../inputs/init.rb'
require_relative '../sequences/loader.rb'
require 'pp'
require 'carioca'



module LightESB
  module Runners
    class HTTP 
      
      def initialize(*args)
        @registry = Carioca::Services::Registry.init :file => Dir.pwd + '/conf/lightesb.registry'
        @configuration  = @registry.start_service :name => 'configuration'
        @log = @registry.start_service :name => 'logclient'
        @input_manager = LightESB::Inputs::Init::new :hash => @configuration.settings[:esb][:sequences]
        @routes = []
        @input_manager.inputs.select{|i| i[:type] == "http"}.each do |input|
          val = input[:params]
          val[:verb].map!(&:to_sym)
          val[:sequence] = input[:sequence]
          @routes.push val
          @log.info " [*] Preparing routes #{input[:params]}"
          return self
        end
      end
      
      def launch
        self.class.const_set :SinatraApp, Class.new(Sinatra::Base)  
        SinatraApp.set :bind, '0.0.0.0'
        @log.info " [!] Defining HTTP Connector on 0.0.0.0"
        @routes.each do |item|
          item[:verb].each do |verb|
            SinatraApp.send(verb, item[:path]) do
              @registry = Carioca::Services::Registry.init :file => Dir.pwd + '/conf/lightesb.registry'
              @log = @registry.start_service :name => 'logclient'
              @log.info " [*] match route #{item[:path]} with verb : #{verb}"
              connector =  LightESB::Connectors::HTTP::new :body => request.body.read , :sequence => item[:sequence] 
              connector.consume
            end
          end
        end
        SinatraApp.run!
      end
      
    end
    
    
    

    
  end
end




         
