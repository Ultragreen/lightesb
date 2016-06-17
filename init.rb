require 'rubygems' 
require "lightesb"
require 'carioca'
require 'carioca/services'
require_relative './lib/lightesb/helpers/application'
require_relative './lib/lightesb/runners/mq.rb'
require_relative './lib/lightesb/runners/direct.rb'
require_relative './lib/lightesb/runners/http.rb'
require 'pp'


module LightESB
  #  init_registry :file => 'conf/lightesb.registry'
  class Application


    include LightESB::Helpers::Application
    def initialize
      @registry = Carioca::Services::Registry.init :file => 'conf/lightesb.registry'
      @configuration = @registry.start_service :name => 'configuration'
      pp @configuration
    end


    def launch
#      runners = ['Direct','MQ','HTTP']
       runners = []
      runners.each do |runner|
        print "Starting LightESB : #{runner} Runner" 
        daemonize :description => "LightESB : #{runner} Runner", :pid_file => "/tmp/#{runner}" do
          runner = "LightESB::Runners::#{runner}".constantize.new
          runner.launch
        end
        puts " [OK]"
      end
    end
    
  end
  
end



esb = LightESB::Application::new
esb.launch
