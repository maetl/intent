module Intent
  module Commands
    class Intent < Base
      def run(args, output)
        if args.empty?
          print_help(output)
        else
          case args.first.to_sym
          when :help
            print_help(output)
          else
            raise Core::Errors::COMMAND_NOT_FOUND
          end
        end
      end
    end
  end
end