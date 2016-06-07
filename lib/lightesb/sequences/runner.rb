require 'securerandom'
require 'pp'
require_relative '../payload.rb'
require_relative './step.rb'
require_relative './definitions.rb'

module Sequences
  class Runner
    
    attr_accessor :flow
    attr_accessor :step_count
    attr_reader :name
    attr_reader :id
    attr_accessor :payload
    
    def initialize(options = {})
      @flow = Array::new
      @id = options[:id] || SecureRandom.uuid 
      @name = options[:name] || 'Default_Sequence'
      @step_count = 0
      @input = 'test'
      @payload  = Payload::new :ref => @id
    end
    
    
    def add_step(options ={})
      options[:sequence] = @id
      p options
      @flow.push Step::new(options)
      @step_count += @flow.last.size
    end
    
    
    def execute
      @flow.each do |step|
        step.run 
      end
    end
    
    
  end
end





