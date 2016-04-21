require 'todo-txt'
require 'intent/todo/manager'

Todo.customize do |options|
  options.require_completed_on = false
end
