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
            documents.inventory.tree

            # documents.inventory.all.each do |task|
            #   output.puts task.to_s
            # end
          when :add
            noun = args[1].to_sym
            case noun
            when :folder then add_folder(args, output)
            when :box then add_box(args, output)
            when :stock then add_stock(args, output)
            else
              raise "Noun not found"
            end
          end
        end
      end

      private

      def inventory_units_of(type)
        documents.inventory.units_of(type).map do |unit|
          [unit.text, unit.tags[:sku]]
        end.to_h
      end

      def add_stock(args, output)
        prompt = TTY::Prompt.new
        type = prompt.select('type of stock:', [:folder, :box])
        ref = self

        unit = prompt.collect do
          key(:sku).ask('sku:', default: ref.generate_id)
          key(:label).ask('label:', default: "[Undocumented #{type.capitalize}]")
          key(:qty).ask('quantity:', default: 1, convert: :int)
        end

        documents.inventory.add_unit!(unit[:label], type, unit[:sku])

        unit[:qty].times do
          label = "[Unlabelled #{type.capitalize}]"
          documents.inventory.add_item!(label, ref.generate_id, type, unit[:sku])
        end
      end

      def add_folder(args, output)
        skus = inventory_units_of(:folder)
        prompt = TTY::Prompt.new
        ref = self
        
        item = prompt.collect do
          key(:sku).select('sku:', skus, filter: true)
          key(:id).ask('id:', default: ref.generate_id)
          key(:label).ask('label:', default: '[Unlabelled Folder]')
          key(:active).yes?('is active:')
        end
        
        label = item[:active] ? "#{item[:label]} @active" : item[:label]

        documents.inventory.add_folder!(label, item[:id], item[:sku])
      end

      def add_box(args, output)
        skus = inventory_units_of(:box)
        prompt = TTY::Prompt.new
        ref = self
        
        item = prompt.collect do
          key(:sku).select('sku:', skus, filter: true)
          key(:id).ask('id:', default: ref.generate_id)
          key(:label).ask('label:', default: '[Unlabelled Box]')
        end
        
        # Repository write pattern
        documents.inventory.add_box!(label, item[:id], item[:sku])

        # Alternative design
        # noun = create_noun(:box, label, tags)
        # Add.invoke(:append, documents.inventory, noun)
      end
    end
  end
end