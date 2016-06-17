require 'securerandom'


module LightESB
  module Sequences
    
    class Step
      attr_accessor :size
      attr_reader :sequence_id
      attr_reader :name
      def initialize(options = {})
        @registry = Carioca::Services::Registry.init :file => 'conf/lightesb.registry'
        @log = @registry.start_service :name => 'log_client'
        @sequence_id = options[:sequence]
        @name = options[:name] || 'default_step_' + @id
        @definition = options[:definition]
        @type = options[:type] || @definition.class.to_s.downcase.to_sym
        @size =  @definition.size
        
      end
      
      def run 
        @log.info " [S] passing Step : #{@type} #{@name}"
        return @definition.run 
      end
      
    end
    
    
    
    
  end
end




