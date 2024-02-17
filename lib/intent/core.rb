module Intent
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
  end
end

require 'intent/core/projects'
require 'intent/core/inventory'
require 'intent/core/inbox'
require 'intent/core/documents'
