lines = File.readlines('07/input').map(&:strip)


beams = [lines[0].index('S')]
part_1 = 0
lines[1..].each do |line|
  new_beams = []
  beams.each do |beam|
    if line[beam] == '.'
      new_beams << beam
    elsif line[beam] == '^'
      new_beams << beam - 1
      new_beams << beam + 1
      part_1 += 1
    end
  end
  beams = new_beams.uniq
end

puts "Part 1: #{part_1}"
