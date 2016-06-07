require 'rubygems' 
require 'carioca'

registry = Carioca::Services::Registry.init :file => 'conf/lightesb.registry'
#registry.discover_builtins
#registry.save!
app  = registry.start_service :name => 'application'
p  app.settings
log = registry.get_service :name => 'logger'
  log.info('myapp') {'my message' }
