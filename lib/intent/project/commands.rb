module Intent
  module Project
    class Commands < Intent::CommandIndex
      def run(args, output=STDOUT)
        if args.empty?
          print_help(output)
        else
          case args.first.to_sym
          when :help
            print_help(output)
          when :status
            Status.run(File.expand_path('~/Projects').to_s)
          when :focus
            # Focus.run()
          when :sync
            # run_sync( Sync.instance )
          end
        end
      end
    end
  end
end
