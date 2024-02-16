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

      def generate_id
        Nanoid.generate(size: 8, alphabet: ID_ALPHABET)
      end

      private
  
      T_CLASS_PREFIX = 'Intent::Commands::'
  
      ID_ALPHABET = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

      def strip_classname
        self.class.to_s.sub(T_CLASS_PREFIX, '').downcase
      end
  
      def help_txt_path
        # TODO: does this work on Windows?
        "#{__dir__}/../text/#{identity}.help.txt"
      end

      def create_noun(type, label, tags)
        Intent::Core::Noun.new(type, label, tags)
      end
    end
  end
end
