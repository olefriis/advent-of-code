require 'pry'
lines = File.readlines('final_image').map(&:strip)

def rotated(lines)
  lines.count.times.map do |y|
    lines.count.times.map do |x|
      lines[x].chars[lines.count-1-y]
    end.join
  end
end

def flipped_vertically(lines)
  lines.reverse
end

def flipped_horizontally(lines)
  lines.map(&:reverse)
end

def find_matches(lines)
  lines = lines.clone # Don't screw this up...
  monster = [
  "                  # ",
  "#    ##    ##    ###",
  " #  #  #  #  #  #   "]

  monster_positions = monster.map do |line|
    (0...line.length).find_all {|i| line[i,1] == '#'}
  end

  #p monster_positions

  for y in 0...lines.count-monster.count
    for x in 0...(lines.first.length - monster.first.length)
      match = true
      for monster_y in 0...monster.count
        match &= monster_positions[monster_y].all? {|position| lines[y+monster_y].chars[x+position] == '#'}
      end
      if match
        for monster_y in 0...monster.count
          monster_positions[monster_y].each {|position| lines[y+monster_y][x+position] = 'O'}
        end
      end
      puts "Match at #{x},#{y}" if match
    end
  end

  remaining_water = lines.map {|line| line.count('#')}.sum
  puts "Remaining water: #{remaining_water}"
end

4.times do |rotations|
  rotated_lines = lines
  rotations.times { rotated_lines = rotated(rotated_lines) }
  puts "Rotated #{rotations} times"
  find_matches(rotated_lines)
  puts 'Flipped horizontally'
  find_matches(flipped_horizontally(rotated_lines))
  puts 'Flipped vertically'
  find_matches(flipped_vertically(rotated_lines))
  puts 'Flipped horizontally and vertically'
  find_matches(flipped_vertically(flipped_horizontally(rotated_lines)))
  puts ''
  puts ''
end