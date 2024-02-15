require 'tty-reader'

module Intent
  module Commands
    class Inventory < Base
      def run(args, output)
        if args.empty?
          print_help(output)
        else
          case args.first.to_sym
          when :help
            print_help(output)
          when :list
            documents.projects.all.each do |task|
              output.puts task.highlight_as_project
            end
          when :add
            noun = args[1].to_sym
            case noun
            when :box then add_box(args, output)
            else
              raise "Noun not found"
            end
          end
        end
      end

      private

      def add_box(args, output)
        reader = TTY::Reader.new

        sku = reader.read_line("sku: ")
        label = reader.read_line("label: ")

        documents.inventory.add_box!(label, sku)
      end
    end
  end
end