module Intent
  module Core
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
  end
end