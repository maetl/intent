require 'todo-txt'
require 'pastel'
require 'fileutils'
require 'intent/todo/manager'

Todo.customize do |options|
  options.require_completed_on = false
end
