#!/usr/bin/ruby
require_relative 'validate'
require_relative 'solve'
require 'json'
require 'open3'

# Grid size w x h passed in via command line args
WIDTH = ARGV[0].to_i
HEIGHT = ARGV[1].to_i

def naive(board)
  mvs = []
  board.grid.each_index do |i|
    cm = board.column_moves[i][1] + board.column_moves[i][2] # Number of moves in column
    unless cm >= HEIGHT
      mvs.push(i)
    end
  end
  idx = rand(mvs.length)
  mvs[idx]
end

# Players
FIRST_PLAYER = 1
SECOND_PLAYER = 2

matrix = Array.new(WIDTH, 0) {Array.new(HEIGHT, 0)}
first_move = rand(WIDTH)
cond = true
jboard = {:grid => matrix, :height => HEIGHT, :player => FIRST_PLAYER, :width => WIDTH}.to_json
move = {:move => first_move}.to_json
valid = Validate.new(jboard, move)
cboard = valid.iboard
while cond
  puts("Move: #{cboard.move}   Player 1:")
  (0...HEIGHT).each do |i|
    (0...WIDTH).each do |j|
      print(cboard.grid[j][i])
    end
    print("\n")
  end
  sps = Solve.new(cboard)
  if sps.term?(cboard)
    cond = false
    break
  end
  sout = sps.solve
  fboard = Board.new(sps.init_grid, sps.move, SECOND_PLAYER)
  puts("Move: #{fboard.move}   Player 2:")
  (0...HEIGHT).each do |i|
    (0...WIDTH).each do |j|
      print(fboard.grid[j][i])
    end
    print("\n")
  end
  if sps.term?(fboard)
    cond = false
    break
  end
  cboard = Board.new(fboard, naive(fboard), FIRST_PLAYER)
end



