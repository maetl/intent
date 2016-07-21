module Intent
  module Review
    class Manager
      def self.run(args, output=STDOUT)
        if args.empty?
          print_help(output)
        else
          puts args
        end
      end

      def self.print_help(output)
        output.puts "usage: review"
      end
    end
  end
end
