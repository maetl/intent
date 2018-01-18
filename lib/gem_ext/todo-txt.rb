# Monkeypatch `todo-txt-gem` to create ANSI decorated terminal output.
class Todo::Task
  def to_s
    pastel = Pastel.new
    if done?
      pastel.strikethrough(super)
    else
      print_open_task(pastel)
    end
  end

  private

  def print_open_task(pastel)
    [
      pastel.red(print_priority),
      pastel.yellow(created_on.to_s),
      text,
      pastel.bold.magenta(print_contexts),
      pastel.bold.blue(print_projects),
      pastel.bold.cyan(print_tags)
    ].reject { |item| !item || item.nil? || item.empty? }.join(' ')
  end
end
