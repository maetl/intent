require 'spec_helper'

describe Intent::Todo do
  before do
    $TODO_TXT_BKP = ENV['TODO_TXT']
    ENV['TODO_TXT'] = "#{__dir__}/samples/todo.txt"
  end

  after do
    ENV['TODO_TXT'] = $TODO_TXT_BKP
  end

  describe 'help' do
    it 'outputs help text when no command given' do
      output = StringIO.new
      Intent::Todo::Commands.exec([], output)

      expect(output.string).to start_with('usage: todo')
    end
  end

  describe 'list' do
    it 'outputs the entire list when no args given' do
      output = StringIO.new
      Intent::Todo::Commands.exec([:list], output)

      output.string.strip.tap do |out|
        result = Strings::ANSI.sanitize(out)
        expect(result).to start_with('(A)')
        expect(result).to end_with('+project')
      end
    end

    it 'filters the list by given project' do
      output = StringIO.new
      Intent::Todo::Commands.exec([:list, '+project'], output)

      expect(output.string).to start_with('A task without any particular focus')
      expect(output.string).to include('+project')
    end

    it 'filters the list by given context' do
      output = StringIO.new
      Intent::Todo::Commands.exec([:list, '@context'], output)

      expect(output.string).to start_with('A task that can only be done in')
      expect(output.string).to include('@context')
    end
  end

  describe 'focus' do
    it 'treats the highest priority task as focused by default' do
      output = StringIO.new
      Intent::Todo::Commands.exec([:focus], output)

      p output.string

      expect(output.string.strip).to eq('(A) The highest priority task')
    end
  end
end
