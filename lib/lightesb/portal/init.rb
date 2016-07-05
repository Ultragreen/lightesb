# -*- coding: utf-8 -*-
require 'sinatra'
require 'slim'
require 'sass'
require 'json'

require "sinatra/streaming"


Dir[File.dirname(__FILE__) + '/controllers/*.rb'].each {|file| require file  unless File.basename(file) == 'init.rb'}
Dir[File.dirname(__FILE__) + '/helpers/*.rb'].each {|file| require file  unless File.basename(file) == 'init.rb'}


#set :public, 'portal/public'
#set :server, %w[puma]
set :static, :enable
set :public_folder, 'portal/public'
set :views, "portal/views"
set :bind, '0.0.0.0'
set :port, '8000'
Slim::Engine.set_options pretty: true


get('/styles.css'){ scss :styles }


def get_menu(current)
  @menu = ['Runners','Sequences','Repository','Scheduler','Administration','logs','Users']
  @current_item = nil
  @current_item = @menu[current] unless current == -1
end

get '/' do
  get_menu -1
  slim :home
end



get '/sequences' do
  get_menu 1
  slim :sequences, :format => :html, :layout => true
end

get '/runners' do
  data = ['LogDispatcher','Scheduler','Direct','MQ','HTTP','InputsMQ']
  @runners = []
  data.each do |i|
    status = (`ps aux | grep 'LightESB : #{i} Runner'|grep -v grep` != "")
    @runners.push({ :service => i, :status => status.to_s})
  end 
  get_menu 0
  slim :runners, :format => :html
end


get '/logs' do
  get_menu 5
  @logs = ['/tmp/lightesb.log','/tmp/direct.log','/tmp/mq.log','/tmp/http.log']
  slim :logs
end

get '/log/:filename' do
  content_type :text
  stream do |out|
    io = IO.popen("tail -f /tmp/#{params[:filename]}")
    procss = io.pid
    out.errback { puts 'err';Process.kill 'TERM',procss; puts 'titi'}
    io.each { |s| out.puts s;  }
  end
end



get '/browse/repository' do
  data = []
  paths =  Dir['/tmp/repository/**/*']
  paths.each do |path|
    basename = File.basename(path)    
    prov  = path.gsub '/tmp/repository/',''
    id = "repository." + prov.gsub('/','.')
    parent = id.chomp(".#{basename}")
    parent = 'repository' if parent == id 
    record = {:id => id, :text => basename, :parent => parent }
    if File.file?(path) then
      record[:icon] = "images/document.png"
      record[:a_attr] = { :href => "/file/#{id}", :target => "contentFrame" }
    end
    data.push record
  end
  data.push({:id => 'repository', :text => "Repository", :parent => '#' })
  content_type :json
  JSON.pretty_generate(data)
end


get '/repository' do
  get_menu 2
  slim :repository
end

get '/file/:filename' do
  get_menu 2
  @filename = params[:filename]
  @content=<<EOF
#include "syscalls.h"
/* getchar:  simple buffered version */
int getchar(void)
{
  static char buf[BUFSIZ];
  static char *bufp = buf;
  static int n = 0;
  if (n == 0) {  /* buffer is empty */
    n = read(0, buf, sizeof buf);
    bufp = buf;
  }
  return (--n >= 0) ? (unsigned char) *bufp++ : EOF;
}
EOF
  slim :file, :layout => false
end



not_found do
  get_menu -1
  @path = request.path
  slim :not_found unless request.path =~ /^\/portal/ 
end
 



