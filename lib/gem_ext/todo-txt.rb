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

  def highlight_as_project
    return to_s unless STDOUT.tty?

    pastel = Pastel.new
    [
      pastel.bold.cyan(print_projects),
      pastel.red(print_project_context)
    ].reject { |item| !item || item.nil? || item.empty? }.join(' ')
  end

  def text=(label)
    @text = label
  end

  private

  def print_project_context
    'active' if contexts.include?('@active')
  end

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
