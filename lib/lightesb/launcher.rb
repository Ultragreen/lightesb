# coding: utf-8
require_relative './runners/init.rb'

module LightESB
  
  class Launcher

    include LightESB::Helpers::Application
    attr_accessor :runners
    
    def initialize
      @runners =   LightESB::Runners.constants.select {|c| Class === LightESB::Runners.const_get(c)}
    end


    def list
      return @runners.map do |i| i.to_s end
    end


    def list_running
      res = []
      list.each do |i|
        res.push i if File::exist? "/tmp/#{i}.pid" 
      end
      return res
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
      unless File::exist? "/tmp/#{runner}.pid" then
        return daemonize :description => "LightESB : #{runner} Runner", :pid_file => "/tmp/#{runner}.pid" do
          runner = "LightESB::Runners::#{runner}".constantize.new
          runner.launch
        end
      end
    end
    
    def stop(options = {})
      runner = options[:runner]
      if File::exist? "/tmp/#{runner}.pid" then
        Process.kill("TERM", `cat /tmp/#{runner}.pid`.to_i)
        FileUtils::rm "/tmp/#{runner}.pid"
        return true
      end
    end
    
  end
end
