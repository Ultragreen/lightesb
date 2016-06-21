require "bunny"

conn = Bunny.new
conn.start

ch   = conn.create_channel
q = ch.queue("lightesb.logs.inputs", :exclusive => false)
q.subscribe(:block => true) do |delivery_info, properties, payload|
  puts "Received #{payload}, message properties are #{properties.inspect}"
end




