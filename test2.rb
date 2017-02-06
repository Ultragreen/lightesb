require 'yaml'



toto = { :name => 'mon_job', :target => :proc, :type => :every, :value => '1s', :proc => 'puts "titi"' }.to_yaml

puts toto


