module Intent
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