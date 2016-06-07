module LightESB
  module Connectors
    class Connector
      
      def initialize(options = {})
        @sequence = options[:sequence]
        @application = Application.get
      end
      
      private
      def init_sequence(content)
        seq= @application.settings[:esb][:sequences][:sequence].select {|item| item[:name] == @sequence }.first
        sequence = Sequences::Loader::new({:hash => seq}).sequence
        sequence.payload.set_input content
        require "bunny"
        conn = Bunny.new
        conn.start
        ch   = conn.create_channel
        q    = ch.queue("lightesb.sequences.inputs")
        ch.default_exchange.publish({ :id => sequence.id, :sequence => @sequence}.to_yaml, :routing_key => q.name)
        
        puts " [x] send "
        conn.close
        
        
      end
    end
  end
end
