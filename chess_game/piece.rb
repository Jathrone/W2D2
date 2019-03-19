require "board"

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
       return board.valid_pos?(pos) && self.board[pos] != NullPiece.instance
    end
end

module Slideable
    private
    HORIZONTAL_DIRS = [[1, 0], [0, 1], [-1, 0], [0, -1]]
    DIAGONAL_DIRS = [[1,1],[1,-1],[-1,1],[-1,-1]]
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
            if self.board[possible_pos] && (self.board[possible_pos].color != self.color)
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
            if self.valid_pos([possible_pos])
                possible_moves << possible_pos
            elsif self.board[possible_pos] && (self.board[possible_pos].color != self.color)
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
        
    end
end

class Rook < Piece

    include Slideable

    def move_dirs
        horizontal_dirs
    end

    def symbol
        
    end
end

class Queen < Piece

    include Slideable

    def move_dirs 
        diagonal_dirs + horizontal_dirs
    end

    def symbol
    end

end


class Knight < Piece

    include Stepable

    def move_diffs 
        [[1, 2], [1, -2], [-1, 2], [-1, -2], [2, 1], [2, -1], [-2, 1], [-2, -1]]
    end