module Intent
  module Core
    class Directory
      attr_reader :path

      def initialize(path, projects)
        @path = path
        @ledger = projects
        @record = projects.all.find { |d| d.tags[:is] == 'directory' && d.text == @path }
      end

      def project
        record.projects.first
      end

      def is_linked?
        !record.nil? && record.projects.any?
      end

      def assign!(project)
        if record.nil?
          @record = Record.new("#{Date.today} #{@path} is:directory type:#{type} sku:#{sku}")
          ledger.append(record)
        else
          record.projects << project
        end

        ledger.save!
      end

      private

      attr_reader :ledger
      attr_reader :record
    end
  end
end