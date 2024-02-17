module Intent
  module Core
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
        all.map { |item| item.projects.first }.uniq
      end

      def linked_directory(path)
        all.find { |item| item.text == path && ['repository', 'directory'].include?(item.tags[:is]) }
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
  end
end