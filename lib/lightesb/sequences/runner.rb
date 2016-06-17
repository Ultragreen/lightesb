require 'securerandom'
require 'pp'
require_relative '../payload.rb'
require_relative './step.rb'
require_relative './definitions.rb'


module LightESB
  module Sequences
    class Runner
      
      attr_accessor :flow
      attr_accessor :step_count
      attr_reader :name
      attr_reader :id
      attr_accessor :payload
      
      def initialize(options = {})
        @registry = Carioca::Services::Registry.init :file => 'conf/lightesb.registry'
        @log = @registry.start_service :name => 'log_client'
        @flow = Array::new
        @id = options[:id] || SecureRandom.uuid 
        @name = options[:name] || 'Default_Sequence'
        @step_count = 0
        @input = 'test'
        @payload  = Payload::new :ref => @id
      end
      
      
      def add_step(options ={})
        options[:sequence] = @id
        @flow.push Step::new(options)
        @step_count += @flow.last.size
      end
      
      
      def execute
        @log.info " [X] execute Sequence #{@name} #{@id} "
        @flow.each do |step|
          step.run 
        end
      end
      
      
    end
  end
end
  
  
  
  
  
