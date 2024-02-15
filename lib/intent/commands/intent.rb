module Intent
  module Commands
    class Intent
      def run(args, output)
        output.puts args
      end
    end
  end
end