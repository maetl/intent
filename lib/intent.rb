#require 'random'
#require 'pathname'

# Pastel still required but deprecated
require 'pastel'
require 'paint'

# CLI UI tools
require 'tty-prompt'
require 'tty-table'
require 'tty-tree'

# Identifiers
require 'nanoid'
#require 'calyx'

# Interact with git repos
require 'logger'
require 'git'

# todo.txt data structure support
require 'todo-txt'
require 'gem_ext/todo-txt'

Todo.customize do |options|
  options.require_completed_on = false
end

# Intent library
require 'intent/version'
require 'intent/env'
require 'intent/args'
require 'intent/core'
#require 'intent/verbs'
require 'intent/commands'
require 'intent/ui/term_color'
require 'intent/dispatcher'
