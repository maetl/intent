module Intent
  module Commands
    class Projects < Base
      def run(args, output)
        if args.empty?
          print_help(output)
        else
          case args.first.to_sym
          when :help
            print_help(output)
          when :list
            documents.projects.all.each do |task|
              output.puts task.highlight_as_project
            end
          when :add then add_project(args, output)
          when :sync then sync_project(args, output)
          else
            raise Errors:COMMAND_NOT_FOUND
          end
        end
      end

      private

      def add_project(args, output)
        prompt = TTY::Prompt.new
        name = prompt.ask('Project identifier: ')
        name = name.downcase.gsub("_", "-").gsub(" ", "-").gsub(/[^0-9a-z\-]/i, '')
        name = "+#{name}" unless name.start_with?('+')
        output.puts name
      end

      def sync_project(args, output)
        result = documents.projects.sync!
        output.puts "Sync projects result: #{result}"
      end
    end
  end
end