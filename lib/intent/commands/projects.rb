require 'readline'

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
          when :add
            add_project(args, output)
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
    end
  end
end