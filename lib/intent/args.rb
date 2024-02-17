module Intent
  class Args
    def initialize(input)
      @arity = input.length

      unless empty?
        case @arity
        when 1 then interpret_args_unary(input[0])
        when 2 then interpret_args_binary(input[0], input[1])
        when 3 then interpret_args_ternary(input[0], input[1], input[2])
        end
      end
    end

    def empty?
      @arity == 0
    end

    private

    def interpret_args_unary(arg1)

    end

    def interpret_args_binary(arg1, arg2)
    end

    def interpret_args_ternary(arg1, arg2, arg3)

    end
  end
end