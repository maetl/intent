module Intent
  module Commands
    class Project < Projects
      def run(args, output)
        if args.empty?
          print_help(output)
        else
          case args.first.to_sym
          when :help
            print_help(output)
          when :link
            case args[1].to_sym
            when :notes then link_notes(args, output)
            else
              raise "Noun not implemented"
            end
          else
            raise Errors:COMMAND_NOT_FOUND
          end
        end
      end

      private

      def link_notes(args, output)
        output.puts Dir.pwd
        output.puts ::Intent::Env.documents_dir
        output.puts ::Intent::Env.computer_serial

        # Check if current working directory is a linked directory
        item = documents.projects.linked_directory(Dir.pwd)
        output.puts item

        #File.symlink("DOCUMENT_DIR/project-name/notes.md", "Projects/project-name/NOTES.md")
      end
    end
  end
end