require 'rubygems'
require "lightesb"
require 'rufus-scheduler'
require "bunny"
require 'carioca'
require 'carioca/services'
require_relative "../backends/redis.rb"
require_relative '../inputs/connectors/injector'

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
        @store  = Backends::RedisDatabase::new :destination => 'scheduler'
        @connection = Bunny.new
        @connection.start
        @channel   = @connection.create_channel
        @queue    = @channel.queue("lightesb.scheduler.inputs")
        @server  = Rufus::Scheduler::new
        @server.extend SchedulerHooks
        @server.init_log
      end


      def unschedule(content)
        name = content[:name]
        @server.unschedule(@store.get :key => name)
        @store.del :key => name
      end


      def schedule(content)
        name = content[:name]
        case content[:target]
        when :sequence
          content[:payload] = ''  if content[:payload].nil?
          aproc = lambda { connector = LightESB::Connectors::Injector::new({:sequence => content[:sequence], :job => content[:name], :payload => content[:payload]})
                           connector.send }
        when :proc
          aproc = eval "lambda { " + content[:proc] + " }" 
        end
        @log.info " [S] Job #{content[:name]} scheduled"
        id = @server.send content[:type],  content[:value], nil, {:name => name} , &aproc
        @store.put :key => name, :value => id
      end

      def init_from_config
        @configuration.settings[:esb][:schedules][:job].each do |job|
          job[:sequence] = job[:sequence].first unless  job[:sequence].nil?
          job[:target] = job[:target].to_sym 
          job[:type] = job[:type].to_sym unless  job[:type].nil?
          schedule job
          p job
        end
      end
      
      def launch
        self.init_from_config
        @log.info " [*] Waiting for schedules in #{@queue.name}."
        begin
          @queue.subscribe(:block => true) do |delivery_info, properties, body|
            content = YAML::load(body)
            content[:name] = 'unknown_job' if content[:name].nil?
            @log.info " [>] Received scheduling action for job #{content[:name]}"

            if content[:type] == :unschedule then
              @log.info " [R] Record unschedule job #{content[:name]}"
              self.unschedule content
            else
              @log.info " [R] Record schedule for job #{content[:name]} #{content[:type]} : #{content[:value]}"
              self.schedule content
            end
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

#toto = LightESB::Runners::Scheduler::new
#toto.launch
