module Intent
  module Commands
    class Todo < Base
      def run(args, output)
        if args.empty?
          print_help(output)
        else
          case args.first.to_sym
          when :add then add_line(args, output)
          else
            raise "Verb not found"
          end
        end
      end

      private

      def add_line(args, output)
        reader = TTY::Reader.new
        line = reader.read_line("task line: ")
        documents.inbox.add_line!(line)
      end
    end
  end
end