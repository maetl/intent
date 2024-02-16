module Intent
  module Verbs
    class Add
      def initialize(documents)
        @documents = documents
      end

      def invoke_prepend(scope, noun)
        ledger = @documents.send(scope)
        ledger.prepend(new Todo::Task(noun.todo_s))
        ledger.save!
      end

      def invoke_append(ledger, noun)
        ledger = @documents.send(scope)
        ledger.append(new Todo::Task(noun.todo_s))
        ledger.save!
      end
    end
  end
end