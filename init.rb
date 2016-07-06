require 'rubygems' 
require "lightesb/application"

esb = LightESB::Application::new
esb.launch

# p esb.start :runner => 'HTTP'
# p esb.start :runner => 'MQ'
# p esb.start :runner => 'HTTP'
# p esb.start :runner => 'LogDispatcher'
# p esb.start :runner => 'Scheduler'


#esb.shutdown

