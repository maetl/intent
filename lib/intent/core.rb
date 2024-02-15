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

    class Projects
      attr_reader :list

      def initialize(db_path)
        @list = List.new(db_path)
      end

      def all
        list.by_not_done
      end
    end

    class Inventory
      attr_reader :list

      def initialize(db_path)
        @list = List.new(db_path)
      end

      def add_folder!(description, sku, archive_dates)
        record = Record.new("#{Date.today} #{description} is:folder sku:#{sku}")
        @list.append(record)
        @list.save!
      end

      def add_box!(description, sku)
        record = Record.new("#{Date.today} #{description} is:box sku:#{sku}")
        @list.append(record)
        @list.save!
      end
    end

    class Inbox
      attr_reader :list

      def initialize(db_path)
        @list = List.new(db_path)
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
