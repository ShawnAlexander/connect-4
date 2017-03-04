require 'board'
class Solve
  NEGINF = -1.0/0.0
  POSINF = 1.0/0.0



  def initialize(board)
    @init_grid = board
    @order = Array.new(board.columns) #Fixed size
    @score = Array.new(board.columns)
    i = 0
    (0...board.columns).each do |col|
      if col % 2 == 0
        i *= -1
        j = (board.columns/2).floor + i
        @order[j] = col
      else
        i += 1
        i *= -1
        j = (board.columns/2).floor + i
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
      if board.total_moves == board.columns * board.rows
        return true
      end
    end
    return false
  end

  def diagsearch(board)
    # Red => Player 1   Blue => Player 2
    found = false
    for i in 0..board.rows - 4
      bluecount = 0
      redcount = 0
      switch = 0
      j = 0
      k = i
      until j >= board.columns or k >= board.rows
        case @grid[j][k]
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
    for i in 3..board.rows - 1
      redcount = 0
      bluecount = 0
      switch = 0
      j = 0
      k = i
      until j >= board.columns or k < 0 do
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
    for i in 1..board.columns - 4
      redcount = 0
      bluecount = 0
      switch = 0
      j = i
      k = board.rows - 1
      until j >= board.columns or k < 0 do
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
    for i in 1..board.columns - 4
      redcount = 0
      bluecount = 0
      switch = 0
      j = i
      k = 0
      until j >= board.columns or k >= board.rows do
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
    until found or j >= board.rows do
      if board.row_moves[j][0] < 4 and board.row_moves[j][1] < 4 # Early determination if row may be skipped
        j += 1
        next
      end
      i = 0
      redcount = 0 #1
      bluecount = 0 #2
      switch = 0 #Switch for consecutive tile color. 1 for red, 2 for blue.
      until i == board.columns do
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
    until found or j >= board.columns do
      if board.column_moves[j][0] < 4 and board.column_moves[j][1] < 4  # Early determination if column may be skipped
        j += 1
        next
      end
      i = 0
      redcount = 0 #1
      bluecount = 0 #2
      switch = 0 #Switch for consecutive tile color. 1 for red, 2 for blue.
      until i == board.rows do
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

  def children(board, player)
    # Returns legal moves in columns ordered by best columns (middle) to worst (outside)
    mvs = []
    nmvs = Array.new(board.columns)
    board.grid.each_index do |i|
      cm = board.column_moves[i][0] + board.column_moves[i][1] # Number of moves in column
      unless cm >= board.rows
        mvs.push(Board(board, i, player))
      end
    end
    if mvs.length > 1
      mvs.each do |b|
        nmvs[@order[b.move]] = b # Map move to ordered position
      end
      nmvs.compact #Remove nil values
      return nmvs
    end
    return mvs
  end

  def ab_negamax_search(board, depth, a, b, player)
    if depth == 0 or term?(board)
      return player * depth
    end
    children = children(board, player)
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

  def solve(board, player)
    # player = 1 does NOT correspond to player 1
    # player = 1 corresponds to root (maximizing) node (the player calling this program)
    # player = -1 corresponds to opponent
    d = board.rows*board.columns - board.total_moves
    ab_negamax_search(board, d, NEGINF, POSINF, player)

  end
end