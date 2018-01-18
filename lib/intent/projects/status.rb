module Intent
  module Projects
    class Status
      def self.run(projects_dir)
        project_index = {}

        Dir["#{projects_dir}/*"].each do |project|
          if Dir.exists?(project) && Dir.exists?("#{project}/.git")
            Dir.chdir(project)
            git_output = `git status`
            project_name = Pathname.new(project).basename

            status = {
              untracked_files: git_output.include?('Untracked files'),
              unstaged_edits: git_output.include?('Changes not staged for commit')
            }

            if status[:untracked_files] || status[:unstaged_edits]
              project_index[project_name] = status
            end
          end
        end

        pastel = Pastel.new

        project_index.each do |key, value|
          result = []
          if value[:untracked_files]
            result << pastel.red('untracked files')
          end
          if value[:unstaged_edits]
            result << pastel.red('unstaged edits')
          end
          puts "#{pastel.bold('+')}#{pastel.bold(key)} contains #{result.join(' and ')}."
        end
      end
    end
  end
end
