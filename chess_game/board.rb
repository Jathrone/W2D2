require_relative "piece.rb"
require 'byebug'

class Board 

    attr_reader :grid, :pieces_hash
    
    def initialize(source_board = nil)
        @pieces_hash = {'white' => Hash.new {|h, k| h[k] = []}, 'black' => Hash.new {|h, k| h[k] = []} } 
        @grid = Array.new(8) {Array.new(8)}
        if source_board.nil?
            (0..7).each do |row_idx|
                (0..7).each do |col_idx|
                    if row_idx == 0
                        case col_idx
                        when 0, 7
                            self[[row_idx, col_idx]] = Rook.new('black', self, [row_idx, col_idx])
                            self.pieces_hash['black']['Rook'] << self[[row_idx, col_idx]]
                        when 1, 6
                            self[[row_idx, col_idx]] = Knight.new('black', self, [row_idx, col_idx])
                            self.pieces_hash['black']['Knight'] << self[[row_idx, col_idx]]
                        when 2, 5
                            self[[row_idx, col_idx]] = Bishop.new('black', self, [row_idx, col_idx])
                            self.pieces_hash['black']['Bishop'] << self[[row_idx, col_idx]]
                        when 3
                            self[[row_idx, col_idx]] = Queen.new('black', self, [row_idx, col_idx])
                            self.pieces_hash['black']['Queen'] << self[[row_idx, col_idx]]
                        when 4
                            self[[row_idx, col_idx]] = King.new('black', self, [row_idx, col_idx])
                            self.pieces_hash['black']['King'] << self[[row_idx, col_idx]]
                        end
                    elsif row_idx == 1
                        self[[row_idx, col_idx]] = Pawn.new('black', self, [row_idx, col_idx])
                        self.pieces_hash['black']['Pawn'] << self[[row_idx, col_idx]]
                    elsif row_idx == 6
                        self[[row_idx, col_idx]] = Pawn.new('white', self, [row_idx, col_idx])
                        self.pieces_hash['white']['Pawn'] << self[[row_idx, col_idx]]
                    elsif row_idx == 7
                        case col_idx
                        when 0, 7
                            self[[row_idx, col_idx]] = Rook.new('white', self, [row_idx, col_idx])
                            self.pieces_hash['white']['Rook'] << self[[row_idx, col_idx]]
                        when 1, 6
                            self[[row_idx, col_idx]] = Knight.new('white', self, [row_idx, col_idx])
                            self.pieces_hash['white']['Knight'] << self[[row_idx, col_idx]]
                        when 2, 5
                            self[[row_idx, col_idx]] = Bishop.new('white', self, [row_idx, col_idx])
                            self.pieces_hash['white']['Bishop'] << self[[row_idx, col_idx]]
                        when 3
                            self[[row_idx, col_idx]] = Queen.new('white', self, [row_idx, col_idx])
                            self.pieces_hash['white']['Queen'] << self[[row_idx, col_idx]]
                        when 4
                            self[[row_idx, col_idx]] = King.new('white', self, [row_idx, col_idx])
                            self.pieces_hash['white']['King'] << self[[row_idx, col_idx]]
                        end
                    else
                        self[[row_idx, col_idx]] = NullPiece.instance
                    end
                end
            end
        else
            source_board.grid.each_with_index do |row, i|
                row.each_with_index do |piece, j|
                    if piece == NullPiece.instance
                        self[[i, j]] = NullPiece.instance
                    else
                        color, position = piece.color.dup, piece.piece_pos.dup
                        self[[i, j]] = piece.class.new(color, self, position)
                        self.pieces_hash[color][piece.class.to_s] << self[[i, j]]
                    end
                end
            end
        end
    end 

    def move_piece(start_pos, end_pos)
        raise PieceClashError if self_clash?(start_pos, end_pos) 
        raise NullPieceError if self[start_pos] == NullPiece.instance
        self[start_pos].pos=end_pos
        self[end_pos] = self[start_pos]
        self[start_pos] = NullPiece.instance
    end 

    def [](pos)
        begin
            x, y = pos
            @grid[x][y]
        rescue NoMethodError
            puts pos
            puts "Ahhh you have caught me at last"
        end

    end

    def []=(pos, val)
        x, y = pos
        @grid[x][y] = val
    end

    def self_clash?(pos1, pos2)
        return true if self[pos1].color == self[pos2].color
        return false
    end

    def valid_pos?(pos)
        x, y = pos
        return false if !(0..7).to_a.include?(x)
        return false if !(0..7).to_a.include?(y)
        return true
    end 

    def opp_color(color)
        color == 'white' ? "black" : "white"
    end 

    def pieces_on_board(color)
        pieces = []
        self.grid.each do |row|
            row.each do |square|
                pieces << square if square.color == color
            end
        end
        return pieces 
    end


    def in_check?(color)
        other_color = opp_color(color) 
        king_pos = pieces_hash[color]["King"][0].piece_pos
        temp_var_pieces = pieces_on_board(other_color)
        temp_var_pieces.each do |piece|
            if piece.moves.include?(king_pos)
                return true 
            end 
        end 
        return false
    end

    def checkmate?(color)
        other_color = opp_color(color) 
        return false if !in_check?(color) 
        pieces_on_board(color).each do |piece|
            return false if !piece.valid_moves.empty?
        end
        return true
    end

    def dup
        return Board.new(self)
    end 
end
