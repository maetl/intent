module Intent
  module Todo
    Task = ::Todo::Task
    List = ::Todo::List
    Syntax = ::Todo::Syntax

    class Manager
      include Syntax

      def self.run(args, output=STDOUT)
        if args.empty?
          print_help(output)
        else
          list = List.new(ENV['TODO_TXT'])
          case args.first.to_sym
          when :add
            output.print "add task: $ "
            input = STDIN.readline.chop
            list.unshift(Task.new("#{Date.today} #{input}")) if input
            list.save!
          when :edit
            exec("#{ENV['EDITOR']} #{ENV['TODO_TXT']}")
          when :list
            filtered_list = list.by_not_done

            unless args[1].nil?
              case args[1][0]
              when '@'
                filtered_list = filtered_list.by_context(args[1]).by_not_done
              when '+'
                filtered_list = filtered_list.by_project(args[1])
              end
            end

            filtered_list.by_not_done.each do |task|
              output.puts task
            end
          when :focus
            focused_list = list.by_not_done

            unless args[1].nil?
              case args[1][0]
              when '@'
                focused_list = focused_list.by_context(args[1])
              when '+'
                focused_list = focused_list.by_project(args[1])
              end
            end

            prioritised_list = focused_list.by_priority('A')
            if prioritised_list.any?
              output.puts prioritised_list.sample
            else
              if focused_list.any?
                output.puts focused_list.sample
              else
                output.puts "No tasks found."
              end
            end
          when :projects
            output.puts list.by_not_done.inject([]) { |p, t| p.concat t.projects }.uniq
          when :contexts
            output.puts list.by_not_done.inject([]) { |c, t| c.concat t.contexts }.uniq
          when :archive
            archive_path = File.dirname(ENV['TODO_TXT'])
            todo_file = ENV['TODO_TXT']
            done_file = "#{archive_path}/done.txt"
            backup_file = "#{archive_path}/.todo.#{Date.today.iso8601}.txt"

            FileUtils.copy(todo_file, backup_file)

            unless File.exists?(done_file)
              output.puts "Creating new `done.txt` in #{archive_path}."
              File.write(done_file, '')
            end

            done_list = ::Todo::List.new(done_file)

            list.by_done.each do |task|
              done_list.push(task)
            end

            File.open(done_file, "w") do |file|
              done_list.sort!.by_done.each do |task|
                file.puts(task)
              end
            end

            File.open(todo_file, "w") do |file|
              list.by_not_done.each do |task|
                file.puts(task)
              end
            end
          when :status
            pastel = Pastel.new
            percentage = true

            active_projects = File.read(ENV['PROJECTS_TXT']).lines.map(&:strip)

            project_names = list.inject([]) do |names, task|
              if (task.projects - active_projects) != task.projects
                names.concat(task.projects)
              else
                names
              end
            end.uniq

            projects = project_names.map do |project|
              high_priority = list.by_not_done.by_project(project).by_priority('A').size
              {
                name: project,
                done: list.by_done.by_project(project).size,
                not_done: list.by_not_done.by_project(project).size - high_priority,
                priority: high_priority
              }
            end

            pad_to = project_names.max { |a,b| a.length <=> b.length }.length + 1
            bar_to = (pad_to * 2).to_f

            projects.each do |project|
              total = project[:done] + project[:not_done] + project[:priority]

              if percentage
                done_ratio = bar_to / total * project[:done]
                not_done_ratio = bar_to / total * project[:not_done]
                priority_ratio = bar_to / total * project[:priority]
              else
                done_ratio = project[:done]
                not_done_ratio = project[:not_done]
                priority_ratio =  project[:priority]
              end

              print project[:name].ljust(pad_to), "|"

              done_ratio.round.times { print pastel.green("█") }
              not_done_ratio.round.times { print pastel.yellow("█") }
              priority_ratio.floor.times { print pastel.red("█") }
              print "\n"
            end
          end
        end
      end

      def self.print_help(output)
        output.puts "usage: todo"
        output.puts
        output.puts "A set of tasks for managing a plain text todo list."
        output.puts
        output.puts "todo list       - list all items in the list"
        output.puts "todo add        - add a new task to the list"
        output.puts "todo focus      - find focus by randomly selecting a task"
        output.puts "todo projects   - list all project tags in the list"
        output.puts "todo contexts   - list all context tags in the list"
        output.puts "todo archive    - archive completed tasks in the nearest `done.txt`"
        output.puts "todo status     - show completion status for all projects"
      end
    end
  end
end
