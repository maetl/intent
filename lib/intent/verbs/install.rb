module Intent
  module Verbs
    class Install
      attr_reader :documents

      def initialize(documents)
        @documents = documents
      end

      def run
        # Preprequisite checks
        # return env_not_detected! unless @documents.env_detected?
        # return already_installed! if @documents.install_detected?

        
      end

    end
  end
end