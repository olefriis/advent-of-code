lines = File.readlines('07/input').map(&:strip)

# Process forward to get part 1
part_1 = 0
lines.reduce([lines[0].index('S')]) do |beams, line|
  beams.flat_map do |beam|
    if line[beam] == '^'
      part_1 += 1
      [beam - 1, beam + 1]
    else
      [beam]
    end
  end.uniq
end
puts "Part 1: #{part_1}"

# Process backward to get part 2
beam_timelines = lines.reverse.reduce([1] * lines.first.length) do |timelines, line|
  line.chars.each_with_index.map do |char, index|
    if char == '^'
      timelines[index - 1] + timelines[index + 1]
    else
      timelines[index]
    end
  end
end
puts "Part 2: #{beam_timelines[lines[0].index('S')]}"
