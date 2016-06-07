require_relative './connector.rb'

module LightESB
  module Connectors
    class File < Connector
      def initialize(options = {})
        @pattern = options[:params][:pattern]
        @path = options[:params][:path] 
        super(options)
      end
      
      def scan
        Dir["#{@path}/#{@pattern}"].each do |file|
          data = @application.settings
          puts "running for #{file}"
          file_content = ::File::readlines(file).join('\n')
          FileUtils::rm file
          init_sequence(file_content)
        end
      end
    end
  end
end  
