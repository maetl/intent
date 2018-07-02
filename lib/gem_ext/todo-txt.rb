# Monkeypatch `todo-txt-gem` to create ANSI decorated terminal output.
class Todo::Task
  def to_s_highlighted
    # If stdout is not a tty, then return the raw string as the output is
    # probably being piped to a file and the color codes will make a mess.
    return to_s unless STDOUT.tty?

    pastel = Pastel.new
    if done?
      # Completed tasks are rendered with a strikethrough
      pastel.strikethrough(to_s)
    else
      # Open tasks delegate to the custom formatting function
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
