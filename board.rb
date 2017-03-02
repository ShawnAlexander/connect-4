class Board
  @@min = 4
  @@max = 16

  attr_reader :grid, :move
  attr_accessor :column_moves, :row_moves, :total_moves

  # Class Methods
  def Board.setrows(rows)
    if rows < @@min or rows > @@max
      raise StandardError, 'Error! Invalid grid size!'
    else
      @@rows = rows
    end
  end

  def Board.setcols(cols)
    if cols < @@min or cols > @@max
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
      @grid = board.grid.clone
      @total_moves = board.total_moves.clone
      @total_moves += 1
      @move = move
      @player = player - 1
      @column_moves = board.column_moves.clone
      @row_moves = board.row_moves.clone
      make_move(move, player)
    elsif board.class == Array
      @grid = board.clone
      @move = move
      @player = player - 1
      # The following are all set by driver validate function
      @total_moves = 0
      @column_moves = Hash.new{|cm, key| cm[key] = [0,0]}
      @row_moves = Hash.new{|rm, key| rm[key] = [0,0]}
    end
  end

  def make_move(move, player)
    @column_moves[move][@player] += 1
    r = (@@rows - 1) - (@column_moves[move][0] + @column_moves[move][1])
    @row_moves[r][@player] += 1
    @grid[@move][r] = player
  end

end