ranges, ids = File.read('05/input').split("\n\n").map(&:lines)
ranges = ranges.map(&:strip)
ids = ids.map(&:strip)

ranges = ranges.map do |line|
  starts_at, ends_at = line.split('-').map(&:to_i)
  [starts_at, ends_at]
end.sort_by! {|start_at, end_at| start_at}

part_2 = 0
while ranges.any?
  next_range = ranges.shift
  next_start = next_range[0]
  next_end = next_range[1]

  # Merge ranges
  while ranges.any? && ranges.first[0] <= next_end + 1
    next_range = ranges.shift
    next_end = [next_end, next_range[1]].max
  end

  puts "Range: #{next_start}-#{next_end}. Size: #{next_end - next_start + 1}"
  part_2 += next_end - next_start + 1
end

puts "Part 2: #{part_2}"
