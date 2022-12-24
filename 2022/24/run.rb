require 'set'
lines = File.readlines('24/input', chomp: true)
WIDTH, HEIGHT = lines.first.size, lines.size

Blizzard = Struct.new(:x, :y, :direction)
blizzards = []
lines.each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    blizzards << Blizzard.new(x, y, char) if ['<', '>', '^', 'v'].include?(char)
  end
end

def move_blizzards(blizzards)
  blizzards.each do |blizzard|
    case blizzard.direction
    when '<'
      blizzard.x -= 1
      blizzard.x = WIDTH-2 if blizzard.x == 0
    when '>'
      blizzard.x += 1
      blizzard.x = 1 if blizzard.x == WIDTH-1
    when '^'
      blizzard.y -= 1
      blizzard.y = HEIGHT-2 if blizzard.y == 0
    when 'v'
      blizzard.y += 1
      blizzard.y = 1 if blizzard.y == HEIGHT-1
    end
  end
end

def blizzard_occupations(blizzards)
  result = Set.new()
  blizzards.each do |blizzard|
    result << [blizzard.x, blizzard.y]
  end
  result
end

def visualize(blizzards, positions)
  map = {}
  0.upto(HEIGHT-1) do |y|
    map[[0, y]] = '#'
    map[[WIDTH-1, y]] = '#'
  end
  0.upto(WIDTH-1) do |x|
    map[[x, 0]] = '#'
    map[[x, HEIGHT-1]] = '#'
  end

  blizzards.each {|blizzard| map[[blizzard.x, blizzard.y]] = blizzard.direction}
  positions_occupied = positions.each {|position| map[position]}
  puts "Positions occupied (there shouldn't be any!): #{positions_occupied}"
  positions.each {|position| map[position] = '.'}

  0.upto(HEIGHT-1) do |y|
    0.upto(WIDTH-1) do |x|
      print (map[[x, y]] || ' ')
    end
    puts ''
  end
end

def move(position, destination, blizzards)
  positions = [position]
  moves = 0
  loop do
    #puts "Moves: #{moves}. Positions: #{positions}"
    #visualize(blizzards, positions)
    move_blizzards(blizzards)
    occupied = blizzard_occupations(blizzards)

    new_positions = Set.new()
    positions.each do |position|
      [[0, -1], [-1,  0], [0,  0], [1,  0], [0, 1]]
        .map {|x, y| [position[0] + x, position[1] + y]}
        .select {|x, y| (x == 1 && y == 0) || (x == WIDTH-2 && y == HEIGHT-1) || (x > 0 && x < WIDTH-1 && y >= 1 && y < HEIGHT-1)}
        .reject {|x, y| occupied.include?([x, y])}
        .each {|pos| new_positions << pos}
    end
    return moves+1 if new_positions.include?(destination)

    positions = new_positions
    moves += 1
  end
end

entrance = [1, 0]
destination = [WIDTH-2, HEIGHT-1]
start_to_end = move(entrance, destination, blizzards)
puts "Part 1: #{start_to_end}"

end_to_start = move(destination, entrance, blizzards)
start_to_end_again = move(entrance, destination, blizzards)
puts "Part 2: #{start_to_end + end_to_start + start_to_end_again}"
