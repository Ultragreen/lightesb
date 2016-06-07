require 'active_support/all'
require 'yaml'

require_relative '../transformers.rb'

class Xml2yaml < Transformer
  def processor(payload)
    return Hash.from_xml( payload ).hash.deep_symbolize_keys.to_yaml
  end
end
