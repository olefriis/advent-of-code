# This is a VERY nice solution, using the shoelace formula to calculate the area of a polygon.
# See https://artofproblemsolving.com/wiki/index.php/Shoelace_Theorem

lines = File.readlines("18/input").map(&:strip)

Segment = Struct.new(:x1, :y1, :x2, :y2)

def solve(commands)
  px = py = 0
  border = 1
  area = 0
  segments = []
  commands.each do |direction, amount|
    newx = px
    newy = py
    case direction
    when 'U'
      newy = py - amount
      border += amount
    when 'D'
      newy = py + amount
    when 'L'
      newx = px - amount
      border += amount
    when 'R'
      newx = px + amount
    end
    area += px*newy - py*newx

    px = newx
    py = newy
  end

  area.abs / 2 + border
end

commands_part1 = lines.map do |line|
  direction, amount, color = line.split(' ')
  [direction, amount.to_i]
end

puts "Part 1: #{solve(commands_part1)}"

commands_part2 = lines.map do |line|
  line =~ /\(\#([0-9a-f]{5})([0-3])\)/ or raise "Bad hex: #{hex}"
  amount, direction = $1, $2
  direction = {
    '0' => 'R',
    '1' => 'D',
    '2' => 'L',
    '3' => 'U'
  }[direction]
  amount = amount.to_i(16)
  [direction, amount]
end

puts "Part 2: #{solve(commands_part2)}"
