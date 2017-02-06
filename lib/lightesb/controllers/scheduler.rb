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
        definition = options[:definition]
        conn = Bunny.new
        conn.start
        ch   = conn.create_channel
        q    = ch.queue("lightesb.scheduler.inputs")
        p definition.to_yaml
        ch.default_exchange.publish(definition.to_yaml, :routing_key => q.name)
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



test = LightESB::Controllers::Scheduler::new
#p test.list_user
#p test.list_system
#p test.info_for :job => 'test_in'
#p test.info_for :job => 'system_input_file_rge_10', :explicit => true


test.send :definition => { :name => 'mon_job', :target => :proc, :type => :every, :value => '3s', :proc => 'puts "titi"' }
sleep 2
p test.list_user

test.unschedule :job => 'mon_job'
sleep 2
p test.list_user
