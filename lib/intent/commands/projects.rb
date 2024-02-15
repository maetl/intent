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
          when :new
            # TODO: replace with TTY::Readline
            while project_name = Readline.readline('project name: ')
              project_slug = project_name.gsub(/[\s]+/, '-').gsub('_', '-')
              project = project_slug.starts_with?('+') ? project_slug : "+#{project_slug}"
              output.puts project_id
            end
          end
        end
      end
    end
  end
end