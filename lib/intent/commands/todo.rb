module Intent
  module Commands
    class Todo
      def run(args, output)
        output.puts args
      end
    end
  end
end