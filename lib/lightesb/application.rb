require 'carioca'
require 'carioca/services'
require_relative './helpers/application'
require_relative './launcher.rb'



module LightESB
  #  init_registry :file => 'conf/lightesb.registry'
  class Application

    attr_reader :registry

    include LightESB::Helpers::Application
    def initialize
      filename = File.dirname(__FILE__) + '/../../conf/lightesb.registry'
      @registry = Carioca::Services::Registry.init :file => filename
      @configuration = @registry.start_service :name => 'configuration'
      @launcher = LightESB::Launcher.new
    end


    def launch
      return @launcher.start_all
    end

    def shutdown
      return @launcher.stop_all
    end

    def start(options = {})
      return @launcher.start options
    end

    def stop(options = {})
      return @launcher.stop options
    end
    
  end
  
end




