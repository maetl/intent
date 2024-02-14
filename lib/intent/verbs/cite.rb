module Intent
  module Verbs
    class Cite
      attr_reader :documents
      attr_reader :projects
      attr_reader :contexts
      attr_reader :bibliography

      def initialize(documents)
        @documents = documents
      end
    end
  end
end