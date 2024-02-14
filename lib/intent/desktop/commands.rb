module Intent
  module Desktop
    class Manager
      def self.run(args, output=STDOUT)
        if args.empty?
          print_help(output)
        else
          case args.first.to_sym
          when :status
            Status.run(File.expand_path('~/Desktop').to_s)
          end
        end
      end

      def self.print_help(output)
        output.puts "usage: desktop"
      end
    end
  end
end
