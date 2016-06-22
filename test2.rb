require "bunny"
require 'yaml'

conn = Bunny.new
conn.start
ch   = conn.create_channel
q    = ch.queue("test")
q2 = ch.queue("testy")
ch.default_exchange.publish({ :name => 'mon_job', :type => :in, :value => '3s', :proc => 'puts "titi"' }.to_yaml, :routing_key => q.name)
ch.default_exchange.publish({ :name => 'mon_job', :type => :in, :value => '3s', :proc => 'puts "titi"' }.to_yaml, :routing_key => q2.name)
conn.close
