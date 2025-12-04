lines = File.readlines('04/input').map(&:strip).map(&:chars)

adjacent = [
  [-1, -1], [-1, 0], [-1, 1],
  [ 0, -1],          [ 0, 1],
  [ 1, -1], [ 1, 0], [ 1, 1]
]

paper_rolls = lines.length.times.flat_map {|y| lines[y].length.times.filter_map {|x| lines[y][x] == '@' ? [x, y] : nil}}.to_set

part_1, part_2 = nil, 0
begin
  accessible = paper_rolls.filter {|(x, y)| adjacent.count {|(dx, dy)| paper_rolls.include?([x + dx, y + dy])} < 4}
  part_1 ||= accessible.length
  part_2 += accessible.length
  paper_rolls -= accessible
end while accessible.any?

puts "Part 1: #{part_1}"
puts "Part 2: #{part_2}"
