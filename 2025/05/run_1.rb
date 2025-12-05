ranges, ids = File.read('05/input').split("\n\n").map(&:lines)
ranges = ranges.map(&:strip)
ids = ids.map(&:strip)

ranges = ranges.map do |line|
  starts_at, ends_at = line.split('-').map(&:to_i)
  (starts_at..ends_at)
end

part_1 = ids.count do |id|
  ranges.any? { |range| range.cover?(id.to_i) }
end

puts "Part 1: #{part_1}"
