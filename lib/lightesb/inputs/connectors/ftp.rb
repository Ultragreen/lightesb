require_relative './connector.rb'
require 'net/ftp'

module LightESB
  module Connectors
    class FTP < Connector
      def initialize(options = {})
        
        @registry = Carioca::Services::Registry.init :file => 'conf/lightesb.registry'
        @log = @registry.get_service :name => 'logclient'
        @pattern = options[:params][:pattern]
        @path = options[:params][:path]
        @server = options[:params][:server]
        @login = options[:params][:login]
        @password = options[:params][:password]
        super(options)
      end
      
      def scan
        begin 
        Net::FTP.open(@server,@login,@password) do |ftp|
          files = ftp.list(@path + @pattern)
          files.map!{|i| i.split.last }
          files.each do |file|
            file = ::File.basename(file)
            @log.info " [>] Getting FTP #{file}"
            puts " [>] Getting FTP #{file}"
            target  = "/tmp/#{file}"
            ftp.gettextfile @path + file, target
            ftp.delete @path + file
            @log.info " [>] running for #{file}"
            puts " [>] running for #{file}"
           
            file_content = ::File::readlines(target).join('\n')
            FileUtils::rm target
            init_sequence(file_content)
          end
        end
        rescue
          @log.error " [E] cannot finalize input viua connector FTP"
        end
      end
    end
  end
end  


