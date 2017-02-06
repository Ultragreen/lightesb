require 'carioca'
require 'carioca/services'
require_relative "../backends/redis.rb"
require "bunny"
require 'yaml'



module LightESB
  module Controllers
    class Scheduler
      def initialize
        filename = File.dirname(__FILE__) + '/../../../conf/lightesb.registry'
        @registry = Carioca::Services::Registry.init :file => filename
        @configuration = @registry.start_service :name => 'configuration'
        @log = @registry.start_service :name => 'logclient', :params => { :source => self.class.to_s }

        @store  = Backends::RedisDatabase::new :destination => 'scheduler'
      end
      
      def send(options = {})
        format  = (options[:format].nil?)? :ruby : options[:format] 
        definition = options[:definition]
        @log.info " [Q] Sending scheduling to MQ."
        conn = Bunny.new
        conn.start
        ch   = conn.create_channel
        q    = ch.queue("lightesb.scheduler.inputs")
        request = definition.to_yaml if format == :ruby
        request = definition if format == :yaml
        ch.default_exchange.publish(request, :routing_key => q.name)
        conn.close
      end
      

      def unschedule(options ={:explicit => false})
        name = options[:job]
        explicit = options[:explicit]
        job = "user_#{job}" unless explicit
        send :definition => { :name => name, :target => :unschedule }
      end

      def info_for (options ={:explicit => false})
        job = options[:job]
        explicit = options[:explicit]
        job = "user_#{job}" unless explicit
        return @store.get :key => job
      end
      
      def list_user
        return list_internal('user_*').map {|i| i.gsub('user_','')}
      end

      def list_system
        return list_internal('system_*')
      end
      
      private
      def list_internal(pattern='*')
        return @store.list(pattern)
      end      
    end
  end
end



