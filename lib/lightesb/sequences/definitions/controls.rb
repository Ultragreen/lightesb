module LightESB
  module Sequences
    
    class Control < Definition
      def run 
        return true
      end
      
    end
    
  end
end

require_relative './controls/conditions.rb'
require_relative './controls/concurrents.rb'



