# -*- coding: utf-8 -*-
require 'sinatra'
require 'slim'
require 'sass'
require 'json'


class Portal < Sinatra::Application

  def initialize(app = nil, params = {})
    super(app)
    @app_name = "LightESB"
    @title = "The tiny mini Ruby ESB"
  end


  configure do
    #set :public, 'portal/public'
    set :static, :enable
    set :public_folder, 'portal/public'
    set :views, "portal/views"
    set :bind, '0.0.0.0'
    Slim::Engine.set_options pretty: true
  end
  
  get('/styles.css'){ scss :styles }



  
  get '/' do
    @menu = ['test']
    slim :home
  end
  
  not_found do
    @path = request.path
    slim :not_found unless request.path =~ /^\/portal/ 
  end
  
end

Dir[File.dirname(__FILE__) + '/controllers/*.rb'].each {|file| require file  unless File.basename(file) == 'init.rb'}
Dir[File.dirname(__FILE__) + '/helpers/*.rb'].each {|file| require file  unless File.basename(file) == 'init.rb'}

Portal.new
