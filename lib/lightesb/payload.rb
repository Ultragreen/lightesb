require_relative "./backends/redis.rb"

module LightESB
  class Payload
    
    def initialize(options = {})
      @ref = options[:id]
      @store  = Backends::RedisDatabase::new :destination => 'payloads'
      @content = {:input => ''}
      if @store.exist?({:key => @ref}) then
        refresh
      else
        persist!
      end
    end
    
    def get
      refresh
      return @content
    end
    
    def get_input
      refresh
      return @content[:input]
    end
    
    def set_input(obj)
      @content[:input] = obj
      persist!
    end
    
    def refresh
      @content = @store.get({:key => @ref})
    end

    
    private
    def persist!
      @store.put :key => @ref, :value => @content
    end
        
  end
end
  
