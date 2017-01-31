require "bunny"
require 'yaml'

conn = Bunny.new
conn.start
ch   = conn.create_channel
q    = ch.queue("lightesb.scheduler.inputs")


toto = { :name => 'mon_job', :target => :proc, :type => :every, :value => '10s', :proc => 'puts "titi"' }.to_yaml

puts toto

ch.default_exchange.publish({ :name => 'mon_job', :target => :proc, :type => :every, :value => '1s', :proc => 'puts "titi"' }.to_yaml, :routing_key => q.name)
ch.default_exchange.publish({ :name => 'mon_job3', :target => :sequence, :type => :in, :value => '3s', :sequence => 'trigger' }.to_yaml, :routing_key => q.name)
sleep 2
ch.default_exchange.publish({ :name => 'mon_job', :type => :unschedule }.to_yaml, :routing_key => q.name)

conn.close
