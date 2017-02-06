require "redis"
require "carioca"
require 'yaml'
require "lightesb"

module LightESB
  module Backends
    class RedisDatabase
      @@store = Redis.new(:host => "localhost", :port => 6379, :db => 1)
      def initialize(options = {})
        @registry = Carioca::Services::Registry.init :file => Dir.pwd + '/conf/lightesb.registry'
        @configuration  = @registry.start_service :name => 'configuration'
        @log = @registry.start_service :name => 'logclient', :params => { :source => self.class.to_s }
        destination = options[:destination] || 'payloads'
        @base = @configuration.settings.esb.base.backends.backend.select {|x| x[:type] == 'redis' and  x[:destination] == destination}.first[:base]
        @@store.select @base.to_i
      end
      
      def list(pattern='*')
         return @@store.keys pattern
      end
      
      def get(options)
        return YAML::load(@@store.get(options[:key]))
      end
      
      def put(options)
        @@store.set options[:key], options[:value].to_yaml
      end
      
      def del(options)
        @@store.del options[:key]
      end
      
      def exist?(options)
        return ( not @@store.get(options[:key]).nil?)
      end
      
    end
  end
  
end
