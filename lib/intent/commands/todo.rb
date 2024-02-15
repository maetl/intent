module Intent
  module Commands
    class Todo < Base
      def run(args, output)
        if args.empty?
          print_help(output)
        else
          case args.first.to_sym
          when :add then add_line(args, output)
          when :list then list_draw(args, output)
          when :focus then focus_draw(args, output)
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

      def focus_draw(args, output)
        pastel = Pastel.new
        documents.inbox.focused_projects.each do |project|
          output.puts pastel.green(project)
        end
      end

      def list_draw(args, output)
        filtered_list = documents.inbox.all

        unless args[1].nil?
          case args[1][0]
          when '@'
            filtered_list = filtered_list.by_context(args[1]).by_not_done
          when '+'
            filtered_list = filtered_list.by_project(args[1])
          end
        end

        filtered_list.by_not_done.each do |task|
          output.puts task.to_s_highlighted
        end
      end
    end
  end
end