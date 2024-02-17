module Intent
  module Core
    class Inventory
      attr_reader :list
      attr_reader :ledger_path

      def initialize(db_path)
        @ledger_path = db_path
        @list = List.new(db_path)
      end

      def all
        list.by_not_done
      end

      def folder_by_id(id)
        all.find { |i| i.tags[:is] == 'folder' && i.tags[:id] == id }
      end

      def folders
        all.filter { |i| i.tags[:is] == 'folder' }
      end

      def items_in(id)
        all.filter { |i| i.tags[:in] == id }
      end

      def unassigned_folders
        all.filter { |i| i.tags[:is] == 'folder' && i.projects.empty? }
      end

      def assigned_folders
        all.filter { |i| i.tags[:is] == 'folder' && i.projects.any? }
      end

      def boxes
        all.filter { |i| i.tags[:is] == 'box' }
      end

      def unassigned_boxes
        all.filter { |i| i.tags[:is] == 'box' && i.projects.empty? }
      end

      def assigned_boxes
        all.filter { |i| i.tags[:is] == 'box' && i.projects.any? }
      end

      def units_of(noun)
        all.filter { |i| i.tags[:is] == 'unit' && i.tags[:type] == noun.to_s }
      end

      def local_computer_id
        all.find { |i| i.tags[:is] == 'computer' && i.tags[:serial] == Env.computer_serial }.tags[:id]
      end

      def add_unit!(description, type, sku)
        record = Record.new("#{Date.today} #{description} is:unit type:#{type} sku:#{sku}")
        @list.append(record)
        @list.save!
      end

      def add_item!(description, id, type, sku, box=nil)
        description << " in:#{box}" unless box.nil?
        record = Record.new("#{Date.today} #{description} id:#{id} is:#{type} sku:#{sku}")
        @list.append(record)
        @list.save!
      end

      def add_folder!(description, id, sku, box=nil)
        add_item!(description, id, :folder, sku, box)
      end

      def add_box!(description, id, sku)
        add_item!(description, id, :box, sku)
      end

      def save!
        @list.save!
      end

      def sync!
        ledger_file = File.basename(ledger_path)

        if repo.status.changed?(ledger_file)
          repo.add(ledger_file)
          repo.commit("Synchronizing inventory [#{Time.new}]")
          repo.push
          true # Result:OK
        else
          false # Result::NO_CHANGES
        end
      end

      private

      def repo
        @repo ||= Git.open(Env.documents_dir, :log => Logger.new(STDERR, level: Logger::INFO))
      end
    end
  end
end