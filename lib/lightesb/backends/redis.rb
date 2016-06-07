require "redis"

module LightESB
  module Backends
    class RedisDatabase
      @@store = Redis.new(:host => "localhost", :port => 6379, :db => 1)
      def initialize(options = {})
        
      end
      
      def get(options)
        return @@store.get(options[:key])
      end
      
      def put(options)
        @@store.set options[:key], options[:value]
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
