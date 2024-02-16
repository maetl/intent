module Intent
  module Env
    def self.documents_dir
      File.expand_path(ENV['INTENT_DOCUMENTS_DIR'] || "").to_s
    end

    def self.inbox_dir
      ENV['INTENT_INBOX_DIR']
    end

    def self.assets_dir
      ENV['INTENT_ARCHIVE_DIR']
    end

    def self.projects_dir
      ENV['INTENT_PROJECTS_DIR']
    end
  end
  
  module Core
    List = ::Todo::List
    Record = ::Todo::Task

    class Noun
      def initialize(type, label, tags)
        @type = type
        @label = label
        @props = lex_props(tags)
        @tags = tags
      end

      private

      def lex_props(tags)
        p tags
      end
    end

    class Projects
      attr_reader :list
      attr_reader :ledger_path

      def initialize(db_path)
        @ledger_path = db_path
        @list = List.new(db_path)
      end

      def all
        list.by_not_done
      end

      def all_tokens
        all.map { |project| project.projects.first }
      end

      def sync!
        ledger_file = File.basename(ledger_path)

        if repo.status.changed?(ledger_file)
          repo.add(ledger_file)
          repo.commit("Synchronizing projects [#{Time.new}]")
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

    class Inbox
      attr_reader :list

      def initialize(db_path)
        @list = List.new(db_path)
      end

      def all
        @list.by_not_done
      end

      def focused
        @list.by_context('@focus').by_not_done
      end

      def focused_projects
        focused.map { |t| t.projects }.flatten.uniq
      end

      def add_line!(line)
        record = Record.new("#{Date.today} #{line}")
        @list.prepend(record)
        @list.save!
      end
    end

    class Documents
      attr_reader :projects
      attr_reader :inventory
      attr_reader :inbox

      def initialize
        @projects = Projects.new("#{Intent::Env.documents_dir}/projects.txt")
        @inventory = Inventory.new("#{Intent::Env.documents_dir}/inventory.txt")
        @inbox = Inbox.new("#{Intent::Env.documents_dir}/todo.txt")
      end
    end
  end
  
  class Dispatcher
    def self.exec_command(command, args, output=STDOUT)
      command = init_command(command).new
      command.run(args, output)
    end

    def self.init_command(command)
      case command
      when :intent then return Commands::Intent
      when :inventory then return Commands::Inventory
      when :projects then return Commands::Projects
      when :project then return Commands::Project
      when :todo then return Commands::Todo
      else
        raise Commands::Errors::COMMAND_NOT_FOUND
      end
    end
  end
end
