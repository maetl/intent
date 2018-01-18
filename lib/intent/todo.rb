require 'todo-txt'
require 'pastel'
require 'gem_ext/todo-txt'
require 'fileutils'
require 'logger'
require 'git'
require 'terminal-notifier'
require 'ghost'
require 'intent/todo/manager'

Todo.customize do |options|
  options.require_completed_on = false
end
