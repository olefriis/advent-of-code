require 'set'
lines = File.readlines('09/input').map(&:strip)

DIRECTIONS = {
  'U' => [0,-1],
  'D' => [0,1],
  'L' => [-1,0],
  'R' => [1,0],
}

def move_knots
  1.upto(@rope.size-1) do |i|
    previous = @rope[i-1]
    current = @rope[i]

    next if previous[0] >= current[0]-1 &&
      previous[0] <= current[0]+1 &&
      previous[1] >= current[1]-1 &&
      previous[1] <= current[1]+1

    if previous[0] < current[0]
      current[0] -= 1
    elsif previous[0] > current[0]
      current[0] += 1
    end
    if previous[1] < current[1]
      current[1] -= 1
    elsif previous[1] > current[1]
      current[1] += 1
    end
  end
end

def process(lines)
  lines.each do |line|
    line =~ /(\w) (\d+)/
    direction, moves = DIRECTIONS[$1], $2.to_i
    moves.times do
      @rope[0][0] += direction[0]
      @rope[0][1] += direction[1]
      move_knots
      @visited << @rope[-1].dup
    end
  end
end

@visited = Set.new
@rope = []
2.times { @rope << [0,0] }
process(lines)
puts "Part 1: #{@visited.size}"

@visited = Set.new
@rope = []
10.times { @rope << [0,0] }
process(lines)
puts "Part 2: #{@visited.size}"
