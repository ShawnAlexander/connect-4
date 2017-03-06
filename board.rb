class Board
  MIN = 4
  MAX = 16
  @@columns = 0
  @@rows = 0
  attr_reader :grid, :move, :player
  attr_accessor :column_moves, :row_moves, :total_moves

  # Class setter methods
  def Board.setrows(rows)
    if rows < MIN or rows > MAX
      raise StandardError, 'Error! Invalid grid size!'
    else
      @@rows = rows
    end
  end
  def Board.setcols(cols)
    if cols < MIN or cols > MAX
      raise StandardError, 'Error! Invalid grid size!'
    else
      @@columns = cols
    end
  end

  def initialize(board, move, player)
    # board is 2D list or another Board object
    # move is column to drop tile in
    # player is either 1 or 2
    # The object represents the state produced by applying the move to the board
    if board.class == Board
      # Some variables need to be explicitly passed by value
      @grid = Array.new(@@columns) {Array.new(@@rows)}
      i = 0
      board.grid.each do |col|
        col.each_index do |row|
          @grid[i][row] = board.grid[i][row]
        end
        i += 1
      end
      @total_moves = board.total_moves
      @move = move
      @player = player
      @column_moves = Hash.new{|cm, key| cm[key] = [0,0,0]}
      @row_moves = Hash.new{|rm, key| rm[key] = [0,0,0]}
      board.column_moves.each do |k, v|
        if v[1] > 0
          @column_moves[k][1] += v[1]
        end
        if v[2] > 0
          @column_moves[k][2] += v[2]
        end
      end
      board.row_moves.each do |k, v|
        if v[1] > 0
          @row_moves[k][1] += v[1]
        end
        if v[2] > 0
          @row_moves[k][2] += v[2]
        end
      end
      make_move(move, player)
    elsif board.class == Array
      @grid = board.clone
      @move = move
      @player = player
      # The following are all set by driver validate function
      @total_moves = 0
      @column_moves = Hash.new{|cm, key| cm[key] = [0,0,0]}
      @row_moves = Hash.new{|rm, key| rm[key] = [0,0,0]}
    end
  end

  def make_move(move, player)
    if @column_moves[move][1] + @column_moves[move][2] + 1 > @@rows
      raise StandardError, 'Error! Illegal move!'
    end
    r = (@@rows - 1) - (@column_moves[move][1] + @column_moves[move][2])
    @column_moves[move][@player] += 1
    @row_moves[r][@player] += 1
    @grid[@move][r] = player
    @total_moves += 1
  end
end