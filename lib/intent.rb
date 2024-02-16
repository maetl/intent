#require 'random'

# Pastel still required but deprecated
require 'pastel'
require 'paint'


require 'tty-prompt'
require 'tty-table'
require 'tty-tree'

# Identifiers
require 'nanoid'
#require 'calyx'

require 'logger'
require 'git'

require 'todo-txt'
require 'gem_ext/todo-txt'

Todo.customize do |options|
  options.require_completed_on = false
end

require 'intent/version'
require 'intent/core'
require 'intent/commands'
require 'intent/ui/term_color'
# require 'intent/todo'
# require 'intent/review'
# require 'intent/projects'
# require 'intent/desktop'

