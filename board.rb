require 'json'
class Board
  @@max = 16
  @@min = 4

  attr_reader :moves

  def initialize(board, move)
    #board is JSON formatted 2D list
    #move is 3-array of row #, col #, player #
    @moves = 0
    @grid = JSON.parse(board)
    validate
    @rows = @grid.length
    @columns = @grid[0].length
  end

  def validate
    if @grid.nil?
      puts 'Error! Could not read JSON file!'
    elsif @grid.respond_to?('each')
      @grid.each do |row|
        if row.respond_to?('each')
          row.each do |tile|
            (0..2).member?(tile) ? (tile == 0 ? next : @moves += 1) : raise StandardError, 'Error! Invalid value in grid object!'
          end
        else
          raise StandardError, 'Error! Could not access column data in rows!'
        end
      end
    else
      raise StandardError, 'Error! Could not access row data!'
    end
  end

  def win?
    if @moves < 7
      return false
    else
      [rowsearch, columnsearch, diagsearch].each do |func|
        a = func
        if a == true
          return true
        end
      end
      return false
    end
  end

  def diagsearch
    found = false
    for i in 0..@rows - 4
      bluecount = 0
      redcount = 0
      switch = 0
      j = 0
      k = i
      until j >= @columns or k >= @rows
        case @grid[k][j]
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
      until j < 0 or k < 0 do
        case @grid[k][j]
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
        case @grid[k][j]
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
        case @grid[k][j]
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

  def rowsearch
    found = false
    j = 0
    until found or j == @rows do
      i = 0
      redcount = 0 #1
      bluecount = 0 #2
      switch = 0 #Switch for consecutive tile color. 1 for red, 2 for blue.
      until i == @columns do
        case @grid[j][i]
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
        if bluecount == 4 or redcount == 4 or redcount + (@columns - i) < 4 or bluecount + (@columns - i) < 4
          found = true
          break
        end
        i += 1
      end
      j += 1
    end
    return found
  end

  def columnsearch
    found = false
    j = 0
    until found or j == @columns do
      i = 0
      redcount = 0 #1
      bluecount = 0 #2
      switch = 0 #Switch for consecutive tile color. 1 for red, 2 for blue.
      until i == @rows do
        case @grid[i][j]
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
        if bluecount == 4 or redcount == 4 or redcount + (@rows - i) < 4 or bluecount + (@rows - i) < 4
          found = true
          break
        end
        i += 1
      end
      j += 1
    end
    return found
  end


end