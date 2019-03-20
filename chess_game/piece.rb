require "singleton"
require_relative "board.rb"

class Piece
    attr_reader :color, :board, :piece_pos
    def initialize(color, board, piece_pos)
        @color = color
        @board = board
        @piece_pos = piece_pos
    end

    def increment_direction(current_pos, direction)
        [current_pos, direction].transpose.map {|x| x.reduce(:+)}
    end 

    def moves
        raise GenericPieceError "A Generic Piece has no moves"
    end

    def valid_pos?(pos)
        return board.valid_pos?(pos) && (self.board[pos]==NullPiece.instance)
    end

    def to_s(emoji)
        return emoji.to_s
    end

    def pos=(val)
        @piece_pos = val
    end

    def valid_moves
        moves = []
        self.moves.each do |end_pos| 
            dup_board = self.board.dup
            dup_board.move_piece(self.piece_pos, end_pos)
            moves << end_pos if !dup_board.in_check?(self.color)
        end 
        return moves 
    end 
end

module Slideable

    HORIZONTAL_DIRS = [[1, 0], [0, 1], [-1, 0], [0, -1]].freeze
    DIAGONAL_DIRS = [[1,1],[1,-1],[-1,1],[-1,-1]].freeze
    public
    def horizontal_dirs
        HORIZONTAL_DIRS
    end

    def diagonal_dirs
        DIAGONAL_DIRS
    end

    # def increment_direction(current_pos, direction)
    #     [current_pos, direction].transpose.map {|x| x.reduce(:+)}
    # end 
    
    def moves
        possible_moves = [] 
        move_dirs.each do |direction|
            possible_pos = increment_direction(piece_pos, direction)
            while self.valid_pos?(possible_pos)
                possible_moves << possible_pos
                possible_pos = increment_direction(possible_pos, direction)
            end 
            if self.board.valid_pos?(possible_pos) && (self.board[possible_pos].color != self.color)
                possible_moves << possible_pos
            end
        end
        possible_moves
    end
end

module Stepable
    def moves
        possible_moves = [] 
        move_diffs.each do |direction| 
            possible_pos = increment_direction(piece_pos, direction)
            if self.valid_pos?(possible_pos)
                possible_moves << possible_pos
            elsif self.board.valid_pos?(possible_pos) && (self.board[possible_pos].color != self.color)
                possible_moves << possible_pos
            end 
        end 
        possible_moves
    end 
end
class Bishop < Piece

    include Slideable

    def move_dirs
        diagonal_dirs
    end

    def symbol
        if self.color == 'white'
            return to_s("♗")
        else
            return to_s("♝")
        end
    end
end

class Rook < Piece

    include Slideable

    def move_dirs
        horizontal_dirs
    end

    def symbol
        if self.color == 'white'
            return to_s("♖")
        else
            return to_s("♜")
        end
    end
end

class Queen < Piece

    include Slideable

    def move_dirs 
        diagonal_dirs + horizontal_dirs
    end

    def symbol
        if self.color == 'white'
            return to_s("♕")
        else
            return to_s("♛")
        end
    end

end


class Knight < Piece

    include Stepable

    def move_diffs 
        [[1, 2], [1, -2], [-1, 2], [-1, -2], [2, 1], [2, -1], [-2, 1], [-2, -1]]
    end

    def symbol 
        if self.color == 'white'
            return to_s("♘")
        else
            return to_s("♞")
        end
    end

end 

class King < Piece
    
    include Stepable 

    def move_diffs
        [[1, 0], [0, 1], [-1, 0], [0, -1], [1, 1], [1, -1],[-1, 1] ,[-1, -1]]
    end 
    def symbol
        if self.color == 'white'
            return to_s("♔")
        else
            return to_s("♚")
        end
    end
end 

class NullPiece 
    attr_reader :symbol, :color

    include Singleton 

    def initialize 
        @color = nil 
        @symbol = '-'
    end
    
end 

class Pawn < Piece

    def initialize(color, board, piece_pos)
        super
        @first_move = true
    end

    def forward_movement
        if self.color == "white"
            return [-1, 0]
        else
            return [1, 0]
        end
    end

    def capture_movement
        if self.color == 'white'
            return [[-1, -1], [-1, 1]]
        else
            return [[1, -1], [1, 1]]
        end
    end
    def moves
        possible_moves = []
        possible_pos = increment_direction(self.piece_pos, forward_movement)
        if valid_pos?(possible_pos)
            possible_moves << possible_pos
            if first_move
                possible_pos = increment_direction(possible_pos, forward_movement)
                if valid_pos?(possible_pos)
                    possible_moves << possible_pos
                end
            end
        end
        capture_movement.each do |direction|
            possible_pos = increment_direction(self.piece_pos, direction)
            if self.board[possible_pos] && !self.board[possible_pos]==NullPiece.instance && self.board[possible_pos].color != self.color
                possible_moves << possible_pos
            end
        end
        possible_moves
    end 

    def having_moved
        first_move = false
    end

    def symbol
        if self.color == 'white'
            return to_s("♙")
        else
            return to_s("♟") 
        end
    end

    private
    attr_reader :first_move
end
