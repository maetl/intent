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
            if args[1].nil?
              # launch into projects selection?
              raise "Need to link to a noun at this stage, sorry"
            else
              case args[1].to_sym
              when :notes then link_notes(args, output)
              else
                raise "Noun not implemented"
              end
            end
          else
            raise Errors:COMMAND_NOT_FOUND
          end
        end
      end

      private

      def link_notes(args, output, needs_assign=false)
        prompt = TTY::Prompt.new

        project = if args.last.start_with?('+')
          # args.last
          # if documents.working_directory.is_linked?
          #   documents.working_directory.project
          # else
          # end
          raise "Good idea and should work but not implemented properly, sorry"
        else
          # TODO: need to test if working_directory is documents_dir
          # 
          if documents.working_directory.is_linked?
            documents.working_directory.project
          else
            needs_assign = true
            p_name = prompt.select('assign directory to project:', documents.projects.all_tokens)
            p_id = prompt.ask('id for this directory:', default: generate_id)
            p_name
          end
        end

        if needs_assign
          c_id = documents.inventory.local_computer_id
          documents.projects.add_directory!(documents.working_directory.path, p_name, p_id, c_id)
        end

        project_ref = project.sub('+', '')

        # Symlink done using maetl local notes convention, this could be improved
        # and made more flexible. Would also be good to delegate this outside
        # of the UI routine link_notes()
        target_path = File.join(Env.documents_dir, project.sub('+', ''), 'notes.md')

        if File.exist?(target_path)
          # TODO: use directory instance given by input filtering so that
          #       operations can work on both working dir and a path provided in the UI
          symbolic_path = File.join(documents.working_directory.path, 'NOTES.md')
          File.symlink(target_path, symbolic_path)
          
          # ignore_path = File.join(documents.working_directory.path, '.gitignore')
          # if File.exist?(ignore_path)
          #   unless File.read(ignore_path).to_s.include?('NOTES.md')
          #     File.write(ignore_path, "NOTES.md\n", mode: 'a+')
          #   end
          # end
        else
          output.puts "#{project} does not have notes"
        end
        
        # output.puts Dir.pwd
        # output.puts ::Intent::Env.documents_dir
        # output.puts ::Intent::Env.computer_serial
        # Check if current working directory is a linked directory
        #item = documents.projects.linked_directory(Dir.pwd)
        #output.puts item
        #File.symlink("DOCUMENT_DIR/project-name/notes.md", "Projects/project-name/NOTES.md")
      end
    end
  end
end