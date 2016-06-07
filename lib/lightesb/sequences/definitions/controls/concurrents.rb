module LightESB
  module Sequences
    
    class Concurrent < Control
      
      def size
        @list.size
      end
      
      def initialize(options = {})
        @list = options[:list] || []
      end
      
      def add(options ={})
        @list.push options[:definition]
      end
      
      
      def run
        threads = []
        @list.each do |step|
          threads << Thread.new { step.run }
        end
        threads.each {|thread| thread.join}
      end
    end
    
  end
  
end



