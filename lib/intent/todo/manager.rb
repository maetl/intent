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
