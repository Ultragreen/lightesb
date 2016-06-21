require 'rubygems'
require "lightesb"
require 'rufus-scheduler'
require "bunny"
require 'carioca'
require 'carioca/services'

module SchedulerHooks
  def on_pre_trigger(job, trigger_time)
    @log.info "triggering job #{job.opts[:name]}..."
  end
  
  def on_post_trigger(job, trigger_time)
    @log.info "triggered job #{job.opts[:name]}."
  end

  def init_log
    @registry = Carioca::Services::Registry.init :file => Dir.pwd + '/conf/lightesb.registry'
    @log = @registry.start_service :name => 'logclient', :params => { :source => self.class.to_s }
  end
    
end

module LightESB
  module Runners
    class Scheduler
      def initialize

        @registry = Carioca::Services::Registry.init :file => Dir.pwd + '/conf/lightesb.registry'
        @configuration  = @registry.start_service :name => 'configuration'
        @log = @registry.start_service :name => 'logclient', :params => { :source => self.class.to_s }
        @connection = Bunny.new
        @connection.start
        @channel   = @connection.create_channel
        @queue    = @channel.queue("lightesb.scheduler.inputs")
        @server  = Rufus::Scheduler::new
        @server.extend SchedulerHooks
        @server.init_log
      end

            
      def launch
        @log.info " [*] Waiting for schedules in #{@queue.name}."
        begin
          @queue.subscribe(:block => true) do |delivery_info, properties, body|
            content = YAML::load(body)
            name = (content[:name])? content[:name] : 'unknown_job'
            @log.info " [x] Received schedule job #{name} #{content[:type]} : #{content[:value]}"
            aproc = eval "lambda { " + content[:proc] + " }"
            @server.send content[:type],  content[:value], nil, {:name => name} , &aproc
          end
        rescue Interrupt => _
          @log.info " [END]  unsuscribe #{@queue.name}."
          @channel.close
          @connection.close
        end
      end
      
    end
  end
end

