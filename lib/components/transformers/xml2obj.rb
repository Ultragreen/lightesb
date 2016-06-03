require 'active_support/all'
require 'yaml'

require_relative '../transformers.rb'

class Xml2obj < Transformer
  def processor(payload)
    return Hash.from_xml( payload ).deep_symbolize_keys
  end
end
