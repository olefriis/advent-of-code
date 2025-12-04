lines = File.readlines('04/input').map(&:strip).map(&:chars)

$adjacent_positions = [
  [-1, -1], [-1, 0], [-1, 1],
  [0, -1],           [0, 1],
  [1, -1],  [1, 0],  [1, 1]
]

def positions_to_remove(lines)
  0.upto(lines.length - 1).flat_map do |y|
    0.upto(lines[y].length - 1).filter_map do |x|
      if lines[y][x] == '@'
        adjacent_rolls = $adjacent_positions.map {|dx, dy| [x + dx, y + dy]}.count do |adjacent_x, adjacent_y|
          adjacent_x >= 0 && adjacent_y >= 0 && adjacent_x < lines[y].length && adjacent_y < lines.length && lines[adjacent_y][adjacent_x] == '@'
        end
        adjacent_rolls < 4 ? [x, y] : nil
      end
    end
  end
end

part_1, part_2 = nil, 0
begin
  to_be_removed = positions_to_remove(lines)
  part_1 ||= to_be_removed.length
  part_2 += to_be_removed.length
  to_be_removed.each {|x, y| lines[y][x] = ' '}
end while to_be_removed.length > 0

puts "Part 1: #{part_1}"
puts "Part 2: #{part_2}"
