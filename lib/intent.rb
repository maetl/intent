#require 'random'
require 'todo-txt'
require 'pastel'
require 'tty-prompt'
require 'tty-table'
require 'tty-tree'
require 'nanoid'
require 'gem_ext/todo-txt'

Todo.customize do |options|
  options.require_completed_on = false
end

require 'intent/version'
require 'intent/core'
require 'intent/commands'
# require 'intent/todo'
# require 'intent/review'
# require 'intent/projects'
# require 'intent/desktop'

