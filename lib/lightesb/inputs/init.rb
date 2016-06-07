
module LightESB
  module Inputs
    class Init
      
    attr_reader :inputs
      
      def initialize(options = {})
        data = options[:hash]
        @direct = [:file,:ftp,:sftp]
        @inputs = []
      data[:sequence].each do |item|
          unless item[:input].nil? then
            direct = @direct.include? item[:input][:type].to_sym
            @inputs.push :sequence => item[:name], :type => item[:input][:type], :params => item[:input][item[:input][:type].to_sym], :direct => direct
          end
      end
      end
      
      
    end
    
  end
end
