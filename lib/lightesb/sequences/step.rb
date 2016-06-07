require 'securerandom'


module LightESB
  module Sequences
    
    class Step
      attr_accessor :size
      attr_reader :sequence_id
      attr_reader :name
      def initialize(options = {})
        @sequence_id = options[:sequence]
        @name = options[:name] || 'default_step_' + @id
        @definition = options[:definition]
        @type = options[:type] || @definition.class.to_s.downcase.to_sym
        @size =  @definition.size
      end
      
      def run 
        return @definition.run 
      end
      
    end
    
    
    
    
  end
end




