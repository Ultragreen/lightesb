require 'rubygems' 
require "lightesb"
require 'carioca'
require 'carioca/services'
require_relative './lib/lightesb/helpers/application'
require_relative './lib/lightesb/launcher.rb'

require 'pp'


module LightESB
  #  init_registry :file => 'conf/lightesb.registry'
  class Application


    include LightESB::Helpers::Application
    def initialize
      @registry = Carioca::Services::Registry.init :file => 'conf/lightesb.registry'
      @configuration = @registry.start_service :name => 'configuration'
      @launcher = LightESB::Launcher.new
    end


    def launch
      @launcher.start_all
    end

    def shutdown
      @launcher.stop_all
    end

    
  end
  
end



esb = LightESB::Application::new
esb.launch

esb.shutdown

