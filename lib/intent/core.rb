module Intent
  module Core
    List = ::Todo::List
    Record = ::Todo::Task

    VERBS = [:add, :assign, :list, :link, :sync]

    NOUNS = {
      inventory: [:unit, :box, :folder, :computer],
      projects: [:project, :directory, :repository],
      todo: [:task]
    }

    class Action
      attr_reader :verb
      attr_reader :noun

      def initialize(verb_sym, noun_r)
        @verb = Verbs.instance_for(verb_sym)
        @noun = Noun.new(noun_r.type, noun_r.label, noun_r.tags)
      end
    end

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
require 'intent/core/directory'
require 'intent/core/documents'
