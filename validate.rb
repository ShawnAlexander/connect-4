require 'json'
class Validate

 def initialize(jboard, move)
   temp = JSON.parse(jboard)
   @gmatrix = temp['grid']  #2D List
   @height = temp['height']
   @width = temp['width']
   @player =temp['player']
   mtemp = JSON.parse(move)
   @move = mtemp['move']
   validate
 end

 def validate   # Called only once on startup
   if @gmatrix.nil?
     puts 'Error! Could not read JSON file!'
   elsif @gmatrix.respond_to?('each')
     @iboard = Board(@gmatrix, @move, @player)
     Board.setcols(@width)
     Board.setrows(@height)
     i = 0
     @gmatrix.each do |col|
       if col.respond_to?('each')
         j = 0
         col.each do |row|
           case row
             when 2
               @iboard.column_moves[i][2] += 1
               @iboard.row_moves[j][2] += 1
               @iboard.total_moves += 1
             when 1
               @iboard.column_moves[i][1] += 1
               @iboard.row_moves[j][1] += 1
               @iboard.total_moves += 1
             when 0
               nil  # Do nothing
             else
               raise StandardError, 'Error! Invalid player number in grid!'
           end
           j += 1
         end
       else
         raise StandardError, 'Error! Could not access column data in rows!'
       end
       i += 1
     end
     @iboard.make_move(@move, @player)
   else
     raise StandardError, 'Error! Could not access row data!'
   end
 end
end