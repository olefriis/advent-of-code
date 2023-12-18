require 'pry'
lines = File.readlines("18/input").map(&:strip)

grid = Set.new

DIRECTIONS = {
  'U' => [0, -1],
  'D' => [0, 1],
  'L' => [-1, 0],
  'R' => [1, 0]
}

px = py = 0
grid << [px, py]
lines.each do |line|
  direction, amount, color = line.split(' ')
  amount.to_i.times do
    #puts "Direction: #{direction}"
    px += DIRECTIONS[direction].first
    py += DIRECTIONS[direction].last
    grid << [px, py]
  end
end

min_x, max_x = grid.map(&:first).minmax
min_y, max_y = grid.map(&:last).minmax

gridlines = []

first_line = []
first_line << false
min_x.upto(max_x) do |x|
  first_line << false
end
first_line << false
gridlines << first_line

min_y.upto(max_y) do |y|
  line = [false]
  min_x.upto(max_x) do |x|
    line << grid.include?([x, y])
  end
  line << false
  gridlines << line
end

last_line = []
last_line << false
min_x.upto(max_x) do |x|
  last_line << false
end
last_line << false
gridlines << last_line

edge = [[0, 0]]
while !edge.empty?
  new_edge = Set.new
  edge.each do |px, py|
    DIRECTIONS.values.each do |dx, dy|
      px2 = px + dx
      py2 = py + dy
      next if px2 < 0 || py2 < 0 || px2 >= gridlines[0].length || py2 >= gridlines.length
      next if gridlines[py2][px2]
      gridlines[py2][px2] = true
      new_edge << [px2, py2]
    end
  end
  edge = new_edge
end

puts "Area: #{(max_x - min_x) * (max_y - min_y)}"

part1 = gridlines.flatten.count(false) + grid.count

puts "Part 1: #{part1}"

# Not correct: 68110
binding.pry
