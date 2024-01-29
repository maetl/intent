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
          when :sync
            todo_path = File.dirname(ENV['TODO_TXT'])
            todo_file = File.basename(ENV['TODO_TXT'])
            git = Git.open(todo_path, :log => Logger.new(STDOUT))
            git.add(todo_file)
            git.add('done.txt')
            git.commit("Update todo list [#{Time.new}]")
            git.push
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
              output.puts task.to_s_highlighted
            end
          when :sample
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
              output.puts prioritised_list.sample.to_s_highlighted
            else
              if focused_list.any?
                output.puts focused_list.sample.to_s_highlighted
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
          when :collect
            output = `chrome-cli list links`
            output.lines.each do |line|
              input = line.split(" ").last
              list.unshift(Task.new("#{Date.today} #{input} @reading")) if input
              list.save!
            end
          when :focus
            timer = if args[1].nil?
               25 # default to pomodoro task length
            else
              args[1].to_i
            end

            blacklist = [
              'mail.google.com',
              'twitter.com',
              'facebook.com',
              'reddit.com',
            ]

            pid = fork do
              sleep timer * 60
              Ghost.store.empty
              TerminalNotifier.notify('Focus block has ended')
            end

            blacklist.each do |hostname|
              Ghost.store.add(Ghost::Host.new(hostname, '::1'))
              Ghost.store.add(Ghost::Host.new(hostname, '127.0.0.1'))
            end

            system("osascript -e 'quit app \"Google Chrome\"'")

            Process.detach pid
          end
        end
      end

      def self.print_help(output)
        output.puts File.read('./todo.help.txt')
      end
    end
  end
end
