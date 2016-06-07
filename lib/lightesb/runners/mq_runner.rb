require "bunny"
require_relative '../application.rb'
require_relative '../sequences/loader.rb'


application = LightESB::Application.init :config_file => '../../conf/lightesb.conf', :xml_input => true


conn = Bunny.new
conn.start

ch   = conn.create_channel
q    = ch.queue("lightesb.sequences.inputs")


puts " [*] Waiting for messages in #{q.name}. To exit press CTRL+C"
begin
  q.subscribe(:block => true) do |delivery_info, properties, body|
    content = YAML::load(body)
    puts " [x] Received name #{content[:sequence]} : #{content[:id]}"
    seq= application.settings[:esb][:sequences][:sequence].select {|item| item[:name] == content[:sequence] }.first
    p application.settings

    sequence = LightESB::Sequences::Loader::new({:hash => seq, :id => content[:id], :name => content[:sequence]}).sequence
    p sequence

    sequence.execute
  end
rescue Interrupt => _
  ch.close
  conn.close
end
