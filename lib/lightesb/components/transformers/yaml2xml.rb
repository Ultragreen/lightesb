require 'xmlsimple'
require 'pp'


class Yaml2xml < Transformer
  def processor(payload)
    hash = YAML.parse(payload).transform #.transform.to_xml(:root => nil, :skip_types => true, :skip_instruct => true)
    pp hash
    return XmlSimple.xml_out(hash, {:keeproot => true, :noescape => true})
  end
end



