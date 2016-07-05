# coding: utf-8
require_relative './runners/init.rb'

module LightESB
  
  class Launchers
    
    attr_accessor :runners
    
    def initialize
      @runners =   LightESB::Runners.constants.select {|c| Class === LightESB::Runners.const_get(c)}
    end
    
    def start_all
      @runners.each do |runner|
        start :runner => runner
      end
    end
    
    def stop_all
      @runners.each do |runner|
        stop :runner => runner
      end
    end
    
    def start(options = {})
      runner = options[:runner]
      print "Starting LightESB : #{runner} Runner"
      daemonize :description => "LightESB : #{runner} Runner", :pid_file => "/tmp/#{runner}" do
        runner = "LightESB::Runners::#{runner}".constantize.new
        runner.launch
      end
      puts " [OK]"
    end
    
    def stop(options = {})
      runner = options[:runner]
      print "Stopping LightESB : #{runner} Runner"
      Process.kill "TERM", `cat /tmp/#{runner}`
      puts " [OK]"²
    end
    
    
  end
end
