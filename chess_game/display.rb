require 'colorize'
require_relative 'cursor.rb'
require_relative 'board.rb' 

class Display 
    attr_reader :cursor 
    attr_reader :board
    def initialize
        @board = Board.new
        @cursor = Cursor.new([0,0], @board)

    end 

    def render
        # @board.grid.each_with_index do |row, i| 
        #     print_line = "" 
        #     row.each_with_index do |square, j| 
        #         current_square = ""
        #         if square.is_a?(Piece)
        #             current_square = " P " 
                    
        #         else
        #             current_square = " - "




        #         end 
        #         if [i, j] == self.cursor.cursor_pos
        #             if self.cursor.selectedbo
        #                 current_square = current_square.green
        #             else
        #                 current_square = current_square.red 
        #             end
        #         end 
        #         print_line += current_square
        #     end
        #     puts print_line 
        # end 
        # return nil 

        @board.grid.each_with_index do |row, i| 
            print_line = "" 
            row.each_with_index do |square, j| 
                current_square = " " + square.symbol+  " " 
                if [i, j] == self.cursor.cursor_pos
                    if self.cursor.selected
                        current_square = current_square.green
                    else
                        current_square = current_square.red 
                    end
                end 
                print_line += current_square
            end
            puts print_line 
        end 
        return nil 
    end 

    def move_around
        system("clear")
        while true 
            self.render 
            @cursor.get_input 
            system("clear")
        end  
    end 
end 


if __FILE__ == $PROGRAM_NAME
    display = Display.new
    display.board.move_piece([6,5], [5,5])
    display.board.move_piece([1,4], [3,4])
    display.board.move_piece([6,6], [4,6])
    display.board.move_piece([0,3], [4,7])
    display.render
    puts display.board.in_check?('white')
end