test = LightESB::Services::Repository::new
file = test.new_file :name => '/test.txt'
p file.content
file.metadata["tests"] = 'test'
file.save! :content => 'test'
