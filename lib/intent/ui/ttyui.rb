require "tty-box"
require "tty-screen"
require "tty-reader"
require "tty-cursor"
require "tty-pager"
require "pastel"
require "todo-txt"

module Intent
  module UI
    class Panel
      def initialize(x, y, width, height)
        @x = x
        @y = y
        @width = width
        @height = height
      end

      def draw
        TTY::Box.frame(
          left: @x,
          top: @y,
          width: @width,
          height: @height,
          align: :center,
          border: :light,
          style: {
            fg: :white,
            border: {
              fg: :white,
            }
          }
        )
      end
    end

    class Window
      def initialize
        @width = TTY::Screen.width
        @height = TTY::Screen.height-1
        @panels = [Panel.new(0, 0, @width, @height)]
        @cursor = TTY::Cursor
      end

      def split_vertical(view1=nil, view2=nil)
        width = (@width / 2) - 1
        height = @height - 2

        @panels << Panel.new(1, 1, width, height)
        @panels << Panel.new(width + 1, 1, width, height)
      end

      def split_horizontal(view1=nil, view2=nil)
        width = @width - 2
        height = (@height / 2) - 2
      end

      def box_frame
        TTY::Box.frame(
          width: @width,
          height: @height,
          align: :center,
          border: :thick,
          style: {
            fg: :blue,
            border: {
              fg: :white,
            }
          }
        )
      end

      def draw
        @cursor.clear_screen

        print box_frame

        @panels.each do |panel|
          @cursor.move_to

          print panel.draw
        end
      end
    end
  end
end

win = Intent::UI::Window.new
win.split_vertical
win.draw
