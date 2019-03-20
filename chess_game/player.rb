

class HumanPlayer
    attr_reader :display, :cursor, :name
    def initialize(name, display)
        @display = display
        @cursor = display.cursor
        @name = name
    end

    def make_move
        until cursor.selected
            @display.render
            puts "#{self.name}, it's your turn!"
            start_pos = self.display.cursor.get_input
            system("clear")
        end
        until !cursor.selected
            @display.render
            puts "#{self.name}, it's your turn!"
            end_pos = self.cursor.get_input
            system("clear")
        end
        return [start_pos, end_pos]
    end
end