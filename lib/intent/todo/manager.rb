module Intent
  module Todo
    class Manager
      def self.run(args)
        if args.empty?
          print_help
        else
          list = ::Todo::List.new(ENV['TODO_TXT'])
          case args.first.to_sym
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
              puts task
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
              puts prioritised_list.sample
            else
              if focused_list.any?
                puts focused_list.sample
              else
                puts "No tasks found."
              end
            end
          when :archive
            archive_path = File.dirname(ENV['TODO_TXT'])
            done_file = "#{archive_path}/__done__.txt"
            todo_file = "#{archive_path}/__todo__.txt"

            unless File.exists?(done_file)
              puts "Creating new `done.txt` in #{archive_path}."
              File.write(done_file, "")
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
          end
        end
      end

      def self.print_help
        puts "usage: todo"
        puts
        puts "A set of tasks for managing a plain text todo list."
        puts
        puts "todo list     - list all items in the list"
        puts "todo focus    - find focus by randomly selecting a task"
        puts "todo archive  - archive completed tasks in the nearest `done.txt`"
      end
    end
  end
end
