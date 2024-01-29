module Intent
  class CommandContext
    def self.exec(args)
      context = new
      context.run(args)
    end

    attr_reader :identity

    def initialize
      @identity = strip_classname
    end

    def print_help(output)
      output.puts(File.read(help_txt_path))
    end

    private

    T_CLASS_PREFIX = 'Intent::'
    T_CLASS_SUFFIX = '::Manager' # TODO: rename to context?

    def strip_classname
      self.class.to_s.sub(T_CLASS_PREFIX, '').sub(T_CLASS_SUFFIX, '').downcase
    end

    def help_txt_path
      [__dir__, identity, identity + '.help.txt'].join('/')
    end
  end
end
