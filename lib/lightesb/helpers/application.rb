module LightESB
  module Helpers
    module Application
      
      # method for daemonize blocks
      # @param [Hash] _options the list of options, keys are symbols
      # @option  _options [String] :description the description of the process, use for $0
      # @option  _options [String] :pid_file the pid filenam
      # @yield a process definion or block given
      # @example usage inline
      #    class Test
      #      include LightESB::Helpers::Application
      #      private :daemonize
      #      def initialize
      #        @loop = Proc::new do
      #          loop do
      #            sleep 1
      #          end
      #        end
      #      end
      #
      #      def run
      #        daemonize({:description => "A loop daemon", :pid_file => '/tmp/pid.file'}, &@loop)
      #      end
      #     end
      #
      # @example usage block
      #    class Test
      #      include LightESB::Helpers::Application
      #      include Dorsal::Privates
      #      private :daemonize
      #      def initialize
      #      end
      #
      #      def run
      #        daemonize :description => "A loop daemon", :pid_file => '/tmp/pid.file' do
      #          loop do
      #            sleep 1
      #          end
      #        end
      #      end
      #     end
      # @return [Fixnum] pid the pid of the forked processus
      def daemonize(_options)
        options = Methodic::get_options(_options)
        options.specify_presences_of :description, :pid_file
        options.validate
        return yield if options[:debug]
#        trap("SIGINT"){ exit! 0 }
#        trap("SIGTERM"){ exit! 0 }
#        trap("SIGHUP"){ exit! 0 }

        fork do 
          Process.daemon 
          File.open(options[:pid_file],"w"){|f| f.puts Process.pid } if options[:pid_file]       
          $0 = options[:description]
          
          yield
          
        end
        return true
      end
    end
  end
end
