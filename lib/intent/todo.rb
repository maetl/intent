require 'todo-txt'
require 'pastel'
require 'intent/todo/manager'

Todo.customize do |options|
  options.require_completed_on = false
end
