require_relative "../backends/redis.rb"
require_relative "../helpers/application.rb"

module LightESB
  module Services
    class Repository
      include LightESB::Helpers::Application
      
      def initialize(options = { :path => '/tmp/lightesb/repository'})
        @path = options[:path].chomp('/')
        make_folder :path => @path unless verify_folder :path => @path
        @store  = Backends::RedisDatabase::new :destination => 'repository'
      end

      def get_file(options)
        if verify_file :name => @path + options[:name]
          return LightESB::Services::RepositoryFile::new :name => options[:name], :path => @path 
        end
        return false
      end

      def delete_file(options)
        name = options[:name]
        if File::exist?(@path + name) then
          File.unlink(@path + name)
          @store.del :key => name 
        end
      end

      def install_file(options)
        name = options[:name]
        source =  options[:source]
        copy_file :source => source, :target => @path + name
        return LightESB::Services::RepositoryFile::new :name => options[:name], :path => @path
      end

      def new_file(options)
        name = options[:name]
        File.open(@path + name, 'w') { |file| file.write "" }
        return  LightESB::Services::RepositoryFile::new :name => options[:name], :path => @path
      end
      
    end
    
    
    
    
    
    
    class RepositoryFile
      attr_accessor :metadata
      
      def initialize(options = {})
        @path = options[:path]
        @name = options[:name]
        @store  = Backends::RedisDatabase::new :destination => 'repository'
        @metadata = {}
        if @store.exist?({:key => @name}) then
          refresh
        else
          persist!
        end      
      end
      
      def content
        return File.readlines(@path + @name).join('\n')
      end

      def save! (options = {})
        persist!
        if options.include? :content then
          File.open(@path + @name, 'w') { |file| file.write options[:content] }
        end 
      end

      
      private
      def refresh
        @metadata = YAML.load(@store.get({:key => @name}))
      end
      
      def persist!
        @store.put :key => @name, :value => @metadata.to_yaml
      end
      
    end
  end
end



