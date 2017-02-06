require 'rubygems'
require "lightesb"
require 'rufus-scheduler'
require "bunny"
require 'yaml'
require 'carioca'
require 'carioca/services'
require_relative "../backends/redis.rb"
require_relative '../inputs/connectors/injector'
require_relative '../inputs/connectors/ftp'
require_relative '../inputs/connectors/file'

module SchedulerHooks
  def on_pre_trigger(job, trigger_time)
    @log.info "triggering job #{job.opts[:name]}..." unless job.opts[:sys] and not @log_system
  end
  
  def on_post_trigger(job, trigger_time)
    @log.info "triggered job #{job.opts[:name]}."  unless job.opts[:sys] and not @log_system
    @store.del job.opts[:name] if job.id =~ /in_.*/
  end

  def init_log
    @registry = Carioca::Services::Registry.init :file => Dir.pwd + '/conf/lightesb.registry'
    @log = @registry.start_service :name => 'logclient', :params => { :source => self.class.to_s }
    @store = Redis.new(:host => "localhost", :port => 6379, :db => 1)
    @configuration  = @registry.start_service :name => 'configuration'
    @base = @configuration.settings.esb.base.backends.backend.select {|x| x[:type] == 'redis' and  x[:destination] == 'scheduler'}.first[:base]
    @store.select @base.to_i
    @log_system = true if @configuration.settings.esb.base.scheduler.logs.system == 'true'
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
        @input_manager = LightESB::Inputs::Init::new :hash => @configuration.settings[:esb][:sequences]
      end


      def unschedule(content, explicit =  false)
        if explicit then
          name = content[:name]
        else
          name = "user_" + content[:name]
        end
        id = @store.get({:key => name})[:id]
        @server.unschedule(id)
        @store.del :key => name
      end


      def schedule(content)
        name = content[:name]
        @log.info content
        case content[:target]
        when :input
          content[:type] = :every
          content[:value] = content[:input][:params][:poll]
          aclass = "LightESB::Connectors::#{content[:input][:type].to_s.capitalize}".constantize
          aproc = lambda { connector = aclass.new content[:input]
                           connector.scan
          }
          record_name = "system_input_#{name}"
        when :sequence
          content[:payload] = ''  if content[:payload].nil?
          aproc = lambda { connector = LightESB::Connectors::Injector::new({:sequence => content[:sequence], :job => content[:name], :payload => content[:payload]})
                           connector.send }
          record_name = "user_#{name}"
        when :proc
          record_name = "user_#{name}"
          aproc = eval "lambda { " + content[:proc] + " }" 
        end
        @log.info " [S] Job #{record_name} scheduled"
        opts = {:name => record_name, :sys => false}
        opts[:sys] = true if content[:target] == :input
        id = @server.send content[:type],  content[:value], nil, opts , &aproc
        @store.put :key => record_name, :value => { :id => id, :content => content }
      end

      def init_from_config
        @configuration.settings[:esb][:schedules][:job].each do |job|
          job[:sequence] = job[:sequence].first unless  job[:sequence].nil?
          job[:target] = job[:target].to_sym 
          job[:type] = job[:type].to_sym unless  job[:type].nil?
          @log.info  " [S] User Job : #{job[:name]} scheduling ..."
          schedule job
          
        end
        @input_manager.inputs.each do |input|
          if input[:direct] == true then
            label = "#{input[:type]}_#{input[:sequence]}_#{input[:params][:poll]}"
            @log.info  " [S] Input Job for #{label} scheduling"
            schedule :name => label, :target => :input, :input => input
          end
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
            case  content[:target]
            when :unschedule then
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

      private
      def get_input_connector
        
      end

      
    end
  end
end

#toto = LightESB::Runners::Scheduler::new
#toto.launch
