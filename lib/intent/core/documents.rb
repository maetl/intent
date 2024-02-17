module Intent
  module Core
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
end
