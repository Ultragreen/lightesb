require "bunny"
require 'yaml'

conn = Bunny.new
conn.start
ch   = conn.create_channel
q    = ch.queue("lightesb.scheduler.inputs")
ch.default_exchange.publish({ :name => 'mon_job', :type => :in, :value => '3s', :proc => 'puts "titi"' }.to_yaml, :routing_key => q.name)
ch.default_exchange.publish({ :name => 'mon_job_reccurent', :type => :every, :value => '3s', :proc => 'puts "tutu"' }.to_yaml, :routing_key => q.name)
conn.close
