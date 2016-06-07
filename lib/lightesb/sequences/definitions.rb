module Sequences
  class Definition
    attr_accessor :name
    attr_accessor :payload
    attr_reader :size

    def initialize(options = {})
      @sequence_id  = options[:sequence]
      @size = 1
      @name = options[:name] || 'default_definition_' + self.class.to_s
      @payload = Payload::new :ref => @sequence_id 
    end
    
    def run 
      return true
    end
    
  end
end

require_relative './definitions/tasks.rb'
require_relative './definitions/controls.rb'




