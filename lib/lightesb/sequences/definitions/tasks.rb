module LightESB
  module Sequences
    
    class Task < Definition
      
      def initialize(options = {})
        super(options)
        @proc = eval "lambda { " + options[:proc] + " }" if options[:proc]
      end
      
      def run 
        @proc.call if @proc
        return true
      end
    end
    
    
  end
end




