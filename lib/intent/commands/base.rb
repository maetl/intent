module Intent
  module Commands
    class Base
      attr_reader :identity
      attr_reader :documents
  
      def initialize
        @identity = strip_classname
        @documents = ::Intent::Core::Documents.new
      end
  
      def print_help(output)
        output.puts(File.read(help_txt_path))
      end
  
      private
  
      T_CLASS_PREFIX = 'Intent::Commands::'
  
      def strip_classname
        self.class.to_s.sub(T_CLASS_PREFIX, '').downcase
      end
  
      def help_txt_path
        # TODO: does this work on Windows?
        "#{__dir__}/../text/#{identity}.help.txt"
      end
    end
  end
end
