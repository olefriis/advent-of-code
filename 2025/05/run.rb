lines = File.readlines('05/input').map(&:strip)
empty_line = lines.index('')
ids = lines[(empty_line + 1)..-1].map(&:to_i)
ranges = lines[0...empty_line].map {|line| line.split('-').map(&:to_i)}.sort_by(&:first)

merged_ranges = []
while ranges.any?
  next_start, next_end = ranges.shift

  while ranges.any? && ranges.first[0] <= next_end + 1
    next_end = [next_end, ranges.shift[1]].max
  end
  merged_ranges << (next_start..next_end)
end

part_1 = ids.count {|id| merged_ranges.any? { |range| range.cover?(id) }}
puts "Part 1: #{part_1}"

part_2 = merged_ranges.sum {|range| range.size }
puts "Part 2: #{part_2}"
