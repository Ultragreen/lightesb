require "bunny"
require 'yaml'

conn = Bunny.new
conn.start
ch   = conn.create_channel
q    = ch.queue("lightesb.scheduler.inputs")
q2 = ch.queue("test")
ch.default_exchange.publish({ :name => 'mon_job', :type => :in, :value => '3s', :proc => 'puts "titi"' }.to_yaml, :routing_key => q.name)
ch.default_exchange.publish({ :name => 'mon_job', :type => :in, :value => '3s', :proc => 'puts "titi"' }.to_yaml, :routing_key => q2.name)
conn.close
