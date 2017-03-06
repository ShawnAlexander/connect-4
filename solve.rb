require_relative 'board'
class Solve
  # Constants
  NEGINF = -1.0/0.0
  POSINF = 1.0/0.0

  attr_accessor :init_grid
  attr_reader :move
  def initialize(board)
    @init_grid = board
    @columns = Board.class_variable_get('@@columns')
    @rows = Board.class_variable_get('@@rows')
    @order = Array.new(@columns) # Fixed size
    @score = Array.new(@columns)
    @nodes_at_depth = {}
    @nodes_at_depth.default = 0
    @nodes_generated = 0
    i = 0
    (0...@columns).each do |col|
      if col % 2 == 0
        i *= -1
        j = (@columns/2).floor + i
        @order[j] = col
      else
        i += 1
        i *= -1
        j = (@columns/2).floor + i
        @order[j] = col
      end
    end
  end

  def term?(board)
    if board.total_moves < 7
      return false
    else
      [rowsearch(board), columnsearch(board), diagsearch(board)].each do |func|
        a = func
        if a
          return true
        end
      end
      if board.total_moves == @columns * @rows
        return true
      end
    end
    return false
  end

  def diagsearch(board)
    # Red => Player 1   Blue => Player 2
    found = false
    for i in 0..@rows - 4
      bluecount = 0
      redcount = 0
      switch = 0
      j = 0
      k = i
      until j >= @columns or k >= @rows
        case board.grid[j][k]
          when 1
            if switch != 1
              switch = 1
              bluecount = 0
            end
            redcount += 1
          when 2
            if switch != 2
              switch = 2
              redcount = 0
            end
            bluecount += 1
          else
            switch = 0
            bluecount = 0
            redcount = 0
        end
        k += 1
        j += 1
      end
      if bluecount >= 4 or redcount >= 4
        found = true
        return found
      end
    end
    for i in 3..@rows - 1
      redcount = 0
      bluecount = 0
      switch = 0
      j = 0
      k = i
      until j >= @columns or k < 0 do
        case board.grid[j][k]
          when 1
            if switch != 1
              switch = 1
              bluecount = 0
            end
            redcount += 1
          when 2
            if switch != 2
              switch = 2
              redcount = 0
            end
            bluecount += 1
          else
            switch = 0
            bluecount = 0
            redcount = 0
        end
        k -= 1
        j += 1
      end
      if bluecount >= 4 or redcount >= 4
        found = true
        return found
      end
    end
    for i in 1..@columns - 4
      redcount = 0
      bluecount = 0
      switch = 0
      j = i
      k = @rows - 1
      until j >= @columns or k < 0 do
        case board.grid[j][k]
          when 1
            if switch != 1
              switch = 1
              bluecount = 0
            end
            redcount += 1
          when 2
            if switch != 2
              switch = 2
              redcount = 0
            end
            bluecount += 1
          else
            switch = 0
            bluecount = 0
            redcount = 0
        end
        k -= 1
        j += 1
      end
      if bluecount >= 4 or redcount >= 4
        found = true
        return found
      end
    end
    for i in 1..@columns - 4
      redcount = 0
      bluecount = 0
      switch = 0
      j = i
      k = 0
      until j >= @columns or k >= @rows do
        case board.grid[j][k]
          when 1
            if switch != 1
              switch = 1
              bluecount = 0
            end
            redcount += 1
          when 2
            if switch != 2
              switch = 2
              redcount = 0
            end
            bluecount += 1
          else
            switch = 0
            bluecount = 0
            redcount = 0
        end
        k += 1
        j += 1
      end
      if bluecount >= 4 or redcount >= 4
        found = true
        return found
      end
    end
    return found
  end

  def rowsearch(board)
    found = false
    j = 0
    until found or j >= @rows do
      if board.row_moves[j][1] < 4 and board.row_moves[j][2] < 4 # Early determination if row may be skipped
        j += 1
        next
      end
      i = 0
      redcount = 0 #1
      bluecount = 0 #2
      switch = 0 #Switch for consecutive tile color. 1 for red, 2 for blue.
      until i == @columns do
        case board.grid[i][j]
          when 1
            if switch != 1
              switch = 1
              bluecount = 0
            end
            redcount += 1
          when 2
            if switch != 2
              switch = 2
              redcount = 0
            end
            bluecount += 1
          else
            switch = 0
            bluecount = 0
            redcount = 0
        end
        if bluecount == 4 or redcount == 4
          found = true
          return found
        end
        i += 1
      end
      j += 1
    end
    return found
  end

  def columnsearch(board)
    found = false
    j = 0
    until found or j >= @columns do
      if board.column_moves[j][1] < 4 and board.column_moves[j][2] < 4  # Early determination if column may be skipped
        j += 1
        next
      end
      i = 0
      redcount = 0 #1
      bluecount = 0 #2
      switch = 0 #Switch for consecutive tile color. 1 for red, 2 for blue.
      until i == @rows do
        case board.grid[i][j]
          when 1
            if switch != 1
              switch = 1
              bluecount = 0
            end
            redcount += 1
          when 2
            if switch != 2
              switch = 2
              redcount = 0
            end
            bluecount += 1
          else
            switch = 0
            bluecount = 0
            redcount = 0
        end
        if bluecount == 4 or redcount == 4
          found = true
          return found
        end
        i += 1
      end
      j += 1
    end
    return found
  end

  def gen_json(board, move)
    p = 1
    if board.player == p
      p = 2
    end
    [{:grid => board.grid, :height => @rows, :player => p, :width => @columns}, {:move => move}]
  end

  def children(board)
    # Returns legal moves in columns ordered by best columns (middle) to worst (outside)
    p = 1
    if board.player == p
      p = 2
    end
    mvs = []
    nmvs = Array.new(@columns)
    board.grid.each_index do |i|
      cm = board.column_moves[i][1] + board.column_moves[i][2] # Number of moves in column
      unless cm >= @rows
        mvs.push(Board.new(board, i, p))
      end
    end
    if mvs.length > 1
      mvs.each do |b|
        nmvs[@order[b.move]] = b # Map move to ordered position
      end
      nmvs.compact! # Remove nil values
      #@nodes_generated += nmvs.length
      return nmvs
    end
    #@nodes_generated += mvs.length
    return mvs
  end

  def ab_negamax_search(board, depth, a, b, player)
    if depth == 0 or term?(board)
      s = player * depth
      @score[board.move] = s
      return s
    end
    children = children(board)
    #@nodes_at_depth[depth] += children.length
    best = NEGINF
    children.each do |child|
      v = -ab_negamax_search(child, depth - 1, -b, -a, -player)
      best = [best, v].max
      a = [a, v].max
      if a >= b
        break
      end
    end
    return best
  end

  def solve
    # player = 1 does NOT correspond to player 1
    # player = 1 corresponds to root (maximizing) node (the player calling this program)
    # player = -1 corresponds to opponent
    d = @rows * @columns - @init_grid.total_moves
    v = ab_negamax_search(@init_grid, d, NEGINF, POSINF, 1)
    move = @score.index(v)
    @move= move
    #puts("Nodes generated: #{@nodes_generated}")
    #puts("Score board: #{@score}")
    #puts('Nodes at depth')
    #@nodes_at_depth.each do |key, value|
    #  puts("#{key} #{value}")
    # Return JSON formatted board and move
    #end
    gen_json(@init_grid, move)
  end
end