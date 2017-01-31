require "rexml/document"
file = File.new( "./conf/lightesb.conf" )
doc = REXML::Document.new file
p doc
