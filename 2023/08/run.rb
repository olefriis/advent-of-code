lines = File.readlines('08/input').map(&:strip)

DIRECTIONS = lines[0].chars

PATHS = {}
lines[2..-1].each do |line|
  line =~ /(.*) = \((.*), (.*)\)/ or raise "Invalid line: #{line}"
  origin, left, right = $1, $2, $3
  PATHS[origin] = [left, right]
end

def solve(position, &block)
  steps = 0
  while !block.call(position)
    direction = DIRECTIONS[steps % DIRECTIONS.length]
    left, right = PATHS[position]
    if direction == 'L'
      position = left
    elsif direction == 'R'
      position = right
    else
      raise "Invalid direction: #{direction}"
    end
    steps += 1
  end
  steps
end

puts "Part 1: #{solve('AAA') {|p| p == 'ZZZ'}}"

positions = PATHS.keys.select {|p| p.end_with?('A')}
part2 = positions.map {|p| solve(p) {|p| p.end_with?('Z')}}.inject(&:lcm)
puts "Part 2: #{part2}"
