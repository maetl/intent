module Intent
  module UI
    # Shim to convert between Pastel to Paint gems
    # without needing to edit existing call sites.
    #
    # It might be helpful to normalize this convention with an API
    # anyway as we generally want to use the 8/16 colour defaults
    # as they pick up user terminal customisation properly, whereas
    # going full 256 or 24 bit colour means generic RGB values are likely
    # to look shit on customised terminal backgrounds.
    #
    # This way we get the benefits of *mostly* sticking to the terminal
    # defaults, while extending the range of colours with a few carefully
    # chosen values.
    class TermColor
      def initialize
        @decoration_scope = []
      end

      def decorate(text, *args)
        decoration_scope.push(*args)
        return_decorator(text)
      end

      def bold(text=nil)
        decoration_scope.push(:bold)
        return_decorator(text)
      end

      def red(text=nil)
        decoration_scope.push(:red)
        return_decorator(text)
      end

      def green(text)
        decoration_scope.push(:green)
        return_decorator(text)
      end

      def blue(text)
        decoration_scope.push(:blue)
        return_decorator(text)
      end

      def yellow(text)
        decoration_scope.push(:yellow)
        return_decorator(text)
      end

      def cyan(text)
        decoration_scope.push(:cyan)
        return_decorator(text)
      end

      def orange(text)
        decoration_scope.push('orange')
        return_decorator(text)
      end

      def brown(text)
        decoration_scope.push('tan')
        return_decorator(text)
      end

      private

      attr_reader :decoration_scope

      def return_decorator(text)
        if text.nil?
          self
        else
          decorated = Paint[text, *decoration_scope]
          decoration_scope.clear
          decorated
        end
      end
    end
  end
end