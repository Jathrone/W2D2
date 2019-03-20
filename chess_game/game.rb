require_relative "player.rb"
require_relative "display.rb"

class Game

    attr_reader :display, :board, :players
    attr_accessor :current_player

    def initialize
        puts "Enter player1 name:"
        name1 = gets.chomp
        puts "Enter player2 name:"
        name2 = gets.chomp
        @display = Display.new
        @board = display.board
        @players = {'white' => HumanPlayer.new(name1, display), 
        'black' => HumanPlayer.new(name2, display)}
        @current_player = 'black'
    end

    def play 
        until self.won?(current_player)
            self.swap_turn!
            notify_players
            begin
                (start_pos, end_pos) = self.players[current_player].make_move
                board.move_piece(current_player, start_pos, end_pos)
            rescue InvalidMoveError => e
                puts e 
                retry
            rescue NullPieceError => e
                puts e 
                retry
            rescue WrongColorError => e
                puts e 
                retry
            rescue PieceClashError => e
                puts e 
                retry
            end
        end
        puts "#{self.players[self.current_player].name} won!"

    end

    def swap_turn!
        self.current_player = (@current_player == 'white' ? 'black' : 'white')
    end
    
    def won?(current_player)
        other_player = self.board.opp_color(current_player)
        return true if self.board.checkmate?(other_player)
        return false
    end
    
    def notify_players
        puts "#{self.players[self.current_player].name}, it's your turn!"
    end
end

if __FILE__ == $PROGRAM_NAME
    Game.new.play
end