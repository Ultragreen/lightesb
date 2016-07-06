require 'rubygems' 
require "lightesb/application"

esb = LightESB::Application::new
#esb.launch
p esb.start :runner => 'HTTP'
#esb.shutdown

