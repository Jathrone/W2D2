require_relative "piece.rb"

class Board 

    attr_reader :grid, :pieces_hash
    
    def initialize()
        i = 0 
        @pieces_hash = {'white' => Hash.new {|h, k| h[k] = []}, 'black' => Hash.new {|h, k| h[k] = []} } 
        @grid = Array.new(8) {Array.new(8)}
        (0..7).each do |row_idx|
            (0..7).each do |col_idx|
                if row_idx == 0
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
                elsif row_idx == 1
                    self[[row_idx, col_idx]] = Pawn.new('white', self, [row_idx, col_idx])
                    self.pieces_hash['white']['Pawn'] << self[[row_idx, col_idx]]
                elsif row_idx == 6
                    self[[row_idx, col_idx]] = Pawn.new('black', self, [row_idx, col_idx])
                    self.pieces_hash['black']['Pawn'] << self[[row_idx, col_idx]]
                elsif row_idx == 7
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
                else
                    self[[row_idx, col_idx]] = NullPiece.instance
                end
            end
        end
    end 

    def move_piece(start_pos, end_pos)
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

    def in_check?(color)
        color == 'white' ? other_color = black : other_color = white 
        king_pos = pieces_hash[color]["King"][0].piece_pos
        pieces_hash[other_color].each do |k, v| 
            v.each do |piece| 
                if piece.moves.include?(king_pos)
                    return true 
                end 
            end 
        end 
        return false
    end
end
