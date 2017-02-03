require_relative '../sequences/loader.rb'
require_relative '../inputs/init.rb'
require_relative '../inputs/connectors/file.rb'
require_relative '../inputs/connectors/ftp.rb'
require 'carioca'

module LightESB
  module Runners

    class Direct
      def initialize
        @registry = Carioca::Services::Registry.init :file => Dir.pwd + '/conf/lightesb.registry'
        @configuration  = @registry.start_service :name => 'configuration'
        @log = @registry.start_service :name => 'logclient', :params => { :source => self.class.to_s }
        @input_manager = LightESB::Inputs::Init::new :hash => @configuration.settings[:esb][:sequences]
      end
      
      def launch
        @log.info " [*] Scanning Direct Inputs"
        begin
          while true do
            @input_manager.inputs.each do |input|
              if input[:direct] == true then
                case input[:type].to_sym
                when :file
                  connector = LightESB::Connectors::File::new input
                  connector.scan
                when :ftp
                  connector = LightESB::Connectors::FTP::new input
                  connector.scan
                end
              end
              sleep 5
            end
          end
        rescue Interrupt => _
          @log.info " [END]  Scanning."
        end
      end
      
    end
    
  end
end
