require_relative "./backends/redis.rb"

class Payload
  
  def initialize(options = {})
    @ref = options[:id]
    @store  = Backends::RedisDatabase::new
    @content = {:input => ''}
    if @store.exist?({:key => @ref}) then
      refresh
    else
      persist!
    end
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
    @content = YAML.load(@store.get({:key => @ref}))
  end

  
  private
  def persist!
    @store.put :key => @ref, :value => @content.to_yaml
  end




end
