require 'active_support/all'
require 'yaml'

require_relative '../transformers.rb'

class Xml2yaml < Transformer
  def processor(payload)
    return Hash.from_xml( payload )
  end
end
