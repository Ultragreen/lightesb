module Sequences
  class Condition < Control
    
    def initialize(options= {})
      super(options)
      @if = options[:if]
      @else = options[:else]
      @step = options[:step]
    end
    
    def run
      if @if then
        return @step.run
      else
        return @else.run
      end
    end
    
  end
  
end





