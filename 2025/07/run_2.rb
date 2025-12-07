lines = File.readlines('07/input').map(&:strip)

beam_timelines = [1] * lines[-1].length
lines[1..].reverse.each do |line|
  new_beam_timelines = []
  line.chars.each_with_index do |char, index|
    if char == '^'
      new_beam_timelines << beam_timelines[index - 1] + beam_timelines[index + 1]
    else
      new_beam_timelines << beam_timelines[index]
    end
  end
  beam_timelines = new_beam_timelines
end
part_2 = beam_timelines[lines[0].index('S')]

puts "Part 2: #{part_2}"
