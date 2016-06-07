require 'sinatra'
require_relative '../application.rb'
require "sinatra/multi_route"
require_relative '../inputs/connectors/http.rb'
require_relative '../inputs/init.rb'
require_relative '../sequences/loader.rb'
require 'pp'


app = LightESB::Application.init :config_file => '../../conf/lightesb.conf', :xml_input => true
routes = []

inputManager = LightESB::Inputs::Init::new :hash => app.settings[:esb][:sequences]
inputManager.inputs.select{|i| i[:type] == "http"}.each do |input|
  val = input[:params]
  val[:verb].map!(&:to_sym)
  val[:sequence] = input[:sequence]
  routes.push val
  puts "Adding routes #{input[:params]}"
end

routes.each do |item|
  item[:verb].each do |verb|
    route verb, item[:path] do
      connector =  LightESB::Connectors::HTTP::new :body => request.body.read , :sequence => item[:sequence] 
      connector.consume
    end
  end
end
