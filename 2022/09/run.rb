require 'set'
lines = File.readlines('09/input').map(&:strip)

DIRECTIONS = {
  'U' => [0,-1],
  'D' => [0,1],
  'L' => [-1,0],
  'R' => [1,0],
}

def move_knots(rope)
  rope.each_cons(2) do |previous, current|
    next if (previous[0] - current[0]).abs <= 1 && (previous[1] - current[1]).abs <= 1

    current[0] -= 1 if previous[0] < current[0]
    current[0] += 1 if previous[0] > current[0]
    current[1] -= 1 if previous[1] < current[1]
    current[1] += 1 if previous[1] > current[1]
  end
end

def solve(lines, rope_length)
  rope = rope_length.times.map { [0,0] }
  visited = Set.new

  lines.each do |line|
    line =~ /(\w) (\d+)/
    direction, moves = DIRECTIONS[$1], $2.to_i
    moves.times do
      rope[0][0] += direction[0]
      rope[0][1] += direction[1]
      move_knots(rope)
      visited << rope.last.dup
    end
  end

  visited.size
end

puts "Part 1: #{solve(lines, 2)}"
puts "Part 2: #{solve(lines, 10)}"
