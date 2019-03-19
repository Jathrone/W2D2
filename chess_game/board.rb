class Piece 

    def initialize
    end 
    
end 

class Board 

    attr_reader :grid 
    
    def initialize()
        i = 0 
        @grid = Array.new(8) { i += 1; Array.new(8) { [1,2,7,8].include?(i) ? Piece.new : nil } }
    end 

    def move_piece(start_pos, end_pos)
        raise NoPieceError if self[start_pos].nil?
        raise PieceClashError if move_clash?(end_pos) 
        self[end_pos] = self[start_pos]
        self[start_pos] = nil
    end 

    def [](pos)
        x, y = pos
        @grid[x][y]
    end

    def []=(pos, val)
        x, y = pos
        @grid[x][y] = val
    end

    def move_clash?(pos)
        return true if !self[pos].nil?
        return false
    end

    def valid_pos?(pos)
        x, y = pos
        return false if !(0..7).to_a.include?(x)
        return false if !(0..7).to_a.include?(y)
        return true
    end 
end
