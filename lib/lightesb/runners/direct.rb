require_relative '../sequences/loader.rb'
require_relative '../inputs/init.rb'
require_relative '../application.rb'
require_relative '../inputs/connectors/file.rb'



app = LightESB::Application.init :config_file => '../../conf/lightesb.conf', :xml_input => true



# config = Configuration::Parser::new({:type => :xml, :content => data}).output
config = app.settings
inputManager = LightESB::Inputs::Init::new :hash => config[:esb][:sequences]

while true do
  inputManager.inputs.each do |input|
    if input[:direct] == true then
      connector = LightESB::Connectors::File::new input
      connector.scan
    end
  end
  sleep 1
end
