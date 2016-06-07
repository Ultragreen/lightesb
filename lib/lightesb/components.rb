class Component
  attr_accessor :input
  def initialize(options = {})
    @input = options[:input]
    @output = options[:output]
    
  end
  

  def processor(payload)
    return payload
  end

  def output
    return processor(@input)
  end
  

  
end

