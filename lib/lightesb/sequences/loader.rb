require_relative '../components/transformers/xml2obj.rb'
require_relative './runner.rb'

module LightESB
  module Sequences
    class Loader
      
      def create_task(struct)
        definition = {:proc => struct[:proc]}
        definition[:name] = struct[:name] if struct[:name]
        definition[:sequence] = @seq.id
        return Sequences::Task::new(definition)
      end
      
      
      def create_condition(struct)
      definition = { :if => create_nested(struct[:if]),
          :step => create_nested(struct[:then])}
        definition[:else] = create_nested(struct[:else]) if struct[:else]
        cond = Sequences::Condition::new(definition)
      end
      
      def create_concurrents(struct)
        para = Sequences::Concurrent.new
        struct.each do |obj|
          para.add :definition => create_nested(obj)
        end
        return para
      end
      
      def create_nested(struct)
        obj = case struct[:type].to_sym
              when :task
                create_task(struct[:task])
              when :condition
                create_condition(struct[:condition])
              when :concurrents
                create_concurrents(struct[:concurrents][:concurrent])
              else           
              end
        return obj
      end
      
      
      
      def initialize(options = {})
        data = options[:hash]
        id = options[:id]
        if id then
          @seq = Sequences::Runner.new({:name => data[:name], :id => id})
        else
          @seq = Sequences::Runner.new :name => data[:name]
        end
        data[:step].each do |step|
          puts "adding Step name=#{step[:name]} type=#{step[:type]}"
          @seq.add_step :definition => create_nested(step), :name => step[:name] 
        end
        return @seq
      end
      
      def sequence 
        @seq
      end
    end
    
  end
end
