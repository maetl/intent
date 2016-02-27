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
            list.each do |task|
              puts task
            end
          when :focus
            unless args[1].nil?
              case args[1][0]
              when '@'
                focused_list = list.by_context(args[1])
              when '+'
                focused_list = list.by_project(args[1])
              else
                focused_list = list.by_context(args[1]).by_project(args[1])
              end
            end

            prioritised_list = focused_list.by_priority('A')
            if prioritised_list.any?
              puts prioritised_list.by_not_done.sample
            else
              puts focused_list.by_not_done.sample
            end
          end
        end
      end

      def self.print_help
        puts "usage: todo"
        puts
        puts "A set of tasks for managing a plain text todo list."
        puts
        puts "todo list - list all items in the list"
      end
    end
  end
end
