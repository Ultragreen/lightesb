# coding: utf-8
require_relative './runners/init.rb'

module LightESB
  
  class Launcher

    include LightESB::Helpers::Application
    attr_accessor :runners
    
    def initialize
      @runners =   LightESB::Runners.constants.select {|c| Class === LightESB::Runners.const_get(c)}
    end
    
    def start_all
      @runners.each do |runner|
        start :runner => runner
      end
      return true
    end
    
    def stop_all
      @runners.each do |runner|
        stop :runner => runner
      end
      return true
    end
    
    def start(options = {})
      runner = options[:runner]
      return daemonize :description => "LightESB : #{runner} Runner", :pid_file => "/tmp/#{runner}.pid" do
        runner = "LightESB::Runners::#{runner}".constantize.new
        runner.launch
      end
    end
    
    def stop(options = {})
      runner = options[:runner]
      Process.kill("TERM", `cat /tmp/#{runner}.pid`.to_i)
      return true 
    end
    
  end
end
