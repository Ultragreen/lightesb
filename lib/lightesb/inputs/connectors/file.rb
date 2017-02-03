require_relative './connector.rb'

module LightESB
  module Connectors
    class File < Connector
      def initialize(options = {})
        @pattern = options[:params][:pattern]
        @path = options[:params][:path] 
        @registry = Carioca::Services::Registry.init :file => 'conf/lightesb.registry'
        @log = @registry.get_service :name => 'logclient'
        super(options)
      end
      
      def scan
        begin
          Dir["#{@path}/#{@pattern}"].each do |file|
            data = @application.settings
            @log.info " [>] running for #{file}"
            file_content = ::File::readlines(file).join('\n')
            FileUtils::rm file
            init_sequence(file_content)
          end
        rescue
          @log.error " [E] cannot finalize input via connector File"
        end
      end
    end
  end
end  
