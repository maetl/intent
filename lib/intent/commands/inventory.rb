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
            tree = TTY::Tree.new(inventory_tree)
            output.puts(tree.render)
          when :add
            noun = args[1].to_sym
            case noun
            when :folder then add_folder(args, output)
            when :box then add_box(args, output)
            when :stock then add_stock(args, output)
            else
              raise "Noun not found"
            end
          when :assign
            noun = args[1].to_sym
            case noun
            when :folder then assign_folder(args, output)
            when :box then assign_box(args, output)
            end
            # CONCEPT:
            # Verbs::Assign.invoke_rewrite()
            # verbs.assign.invoke_rewrite(documents.inventory, noun)
          when :sync then sync_inventory(args, output)
          else
            raise Errors:COMMAND_NOT_FOUND
          end
        end
      end

      private

      def inventory_tree
        color = ::Intent::UI::TermColor.new
        root = {}
        documents.inventory.boxes.each do |box|
          color_code = case box.tags[:id][0].downcase.to_sym
          when :g then :green
          when :y then :yellow
          when :b then :blue
          when :r then :red
          else
            :white
          end
          box_key = "#{color.bold.decorate(box.tags[:id], color_code)} #{box.text}"
          child_items = documents.inventory.items_in(box.tags[:id]).map do |item|
            "#{color.bold.decorate(item.tags[:id], color_code)} #{item.text}"
          end
          root[box_key] = child_items
        end
        root
      end

      # ui format reader
      def inventory_units_of(type)
        documents.inventory.units_of(type).map do |unit|
          [unit.text, unit.tags[:sku]]
        end.to_h
      end

      # ui format reader
      def inventory_unassigned_folders
        folder_types = documents.inventory.units_of(:folder)
        documents.inventory.unassigned_folders.map do |folder|
          unit_label = folder_types.find { |f| f.tags[:sku] == folder.tags[:sku] } 
          ["#{folder.text} #{folder.tags[:id]} (#{unit_label.text})", folder.tags[:id]]
        end.to_h
      end

      # ui format reader
      def inventory_assigned_boxes
        box_types = documents.inventory.units_of(:box)
        documents.inventory.assigned_boxes.map do |box|
          unit_label = box_types.find { |f| f.tags[:sku] == box.tags[:sku] } 
          ["#{box.text} #{box.tags[:id]} (#{unit_label.text})", box.tags[:id]]
        end.to_h
      end

      # ui format reader
      def inventory_unassigned_boxes
        box_types = documents.inventory.units_of(:box)
        documents.inventory.unassigned_boxes.map do |box|
          unit_label = box_types.find { |f| f.tags[:sku] == box.tags[:sku] } 
          ["#{box.text} #{box.tags[:id]} (#{unit_label.text})", box.tags[:id]]
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
        projects = documents.projects.all_tokens
        prompt = TTY::Prompt.new
        ref = self
        
        item = prompt.collect do
          key(:sku).select('sku:', skus, filter: true)
          key(:id).ask('id:', default: ref.generate_id)
          key(:label).ask('label:', default: '[Unlabelled Folder]')
        end

        should_assign_projects = prompt.yes?('assign to projects:')

        if should_assign_projects
          assigned_projects = prompt.multi_select('projects:', projects, filter: true)
          label = "#{item[:label]} #{assigned_projects.join(' ')}"
        else
          label = item[:label]
        end

        should_file_in = prompt.select('file in:', {
          "Active, not in box" => :active,
          "Unassigned box" => :unassigned,
          "Assigned project box" => :assigned
        })

        case should_file_in
        when :active 
          label << " @active"
          in_box = nil
        when :unassigned
          in_box = prompt.select('box', inventory_unassigned_boxes)
        when :assigned
          # TODO: filter on selected projects only
          in_box = prompt.select('box:', inventory_assigned_boxes)
        end

        documents.inventory.add_folder!(label, item[:id], item[:sku], in_box)
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
        documents.inventory.add_box!(item[:label], item[:id], item[:sku])

        # Alternative design
        # noun = create_noun(:box, label, tags)
        # Add.invoke(:append, documents.inventory, noun)
      end

      def assign_folder(args, output)
        projects = documents.projects.all_tokens
        folders = inventory_unassigned_folders
        prompt = TTY::Prompt.new

        folder_id = prompt.select('folder:', folders)
        folder = documents.inventory.folder_by_id(folder_id)
        
        details = prompt.collect do
          key(:projects).multi_select('projects:', projects)
          key(:label).ask('label:', default: folder.text)
          # TODO: is active
        end

        folder.text = details[:label]
        folder.projects.concat(details[:projects])
        documents.inventory.save!
      end

      def assign_box(args, output)
        projects = documents.projects.all_tokens
        boxes = inventory_unassigned_boxes
        prompt = TTY::Prompt.new

        box_id = prompt.select('box:', boxes)
        box = documents.inventory.box_by_id(box_id)
        
        details = prompt.collect do
          key(:projects).multi_select('projects:', projects)
          key(:label).ask('label:', default: box.text)
          # TODO: is active
        end

        box.text = details[:label]
        box.projects.concat(details[:projects])
        documents.inventory.save!
      end

      def sync_inventory(args, output)
        result = documents.inventory.sync!
        output.puts "Sync inventory result: #{result}"
      end
    end
  end
end