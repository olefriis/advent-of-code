require 'set'
GUSTS = File.read('17/input').strip.split('')

rocks = [
  # ####
  [[0, 0], [1, 0], [2, 0], [3, 0]],

  # .#.
  # ###
  # .#.
  [[1, 2], [0, 1], [1, 1], [2, 1], [1, 0]],

  # ..#
  # ..#
  # ###
  [[2, 2], [2, 1], [0, 0], [1, 0], [2, 0]],
  
  # #
  # #
  # #
  # #
  [[0, 3], [0, 2], [0, 1], [0, 0]],
  
  # ##
  # ##
  [[0, 1], [1, 1], [0, 0], [1, 0]],
]

def create_chamber
  result = Set.new
  # Add the floor
  7.times {|x| result << [x, 0]}
  result
end

def overlap?(rock, position, chamber)
  rock.any? do |x, y|
    chamber.include?([x + position[0], y + position[1]]) ||
    x + position[0] < 0 ||
    x + position[0] > 6
  end
end

def visualize_top(highest_rock, chamber)
  highest_rock.downto(highest_rock - 20) do |y|
    0.upto(6) do |x|
      print chamber.include?([x, y]) ? '#' : ' '
    end
    puts ''
  end
end

def place_rock(rock, highest_rock, chamber, gust_index)
  position = [2, highest_rock+4]

  loop do
    # Perform a gust
    gust = GUSTS[gust_index]
    gust_index = (gust_index + 1) % GUSTS.length
    if gust == '<'
      potential_position = [position[0]-1, position[1]]
      position = overlap?(rock, potential_position, chamber) ? position : potential_position
    elsif gust == '>'
      potential_position = [position[0]+1, position[1]]
      position = overlap?(rock, potential_position, chamber) ? position : potential_position
    else
      raise 'Unknown gust'
    end

    # Move down
    potential_position = [position[0], position[1]-1]
    if overlap?(rock, potential_position, chamber)
      rock.each do |x, y|
        chamber << [x + position[0], y + position[1]]
      end
      rock_height = rock.map {|_, y| y}.max
      highest_rock = [highest_rock, position[1] + rock_height].max
      break
    else
      position = potential_position
    end
  end

  [highest_rock, gust_index]
end

def top_shape(highest_rock, chamber)
  lines = []
  # All 7 columns are available at the top
  last_line = [true, true, true, true, true, true, true]
  y_from_top = -1
  loop do
    y = highest_rock - y_from_top
    line = 7.times.map do |x|
      can_move_from_previous_line = (x > 0 && last_line[x-1]) || last_line[x] || (x < 6 && last_line[x+1])
      is_empty = !chamber.include?([x, y])
      can_move_from_previous_line && is_empty
    end
    #puts "New line: #{line.inspect}"
    break unless line.any?
    lines << line
    last_line = line
    y_from_top += 1
  end

  lines.map {|line| line.map {|visible| visible ? '#' : ' '}.join('')}.join("\n")
end

chamber = create_chamber
rock_index = 0
gust_index = 0
highest_rock = 0
2022.times do
  rock = rocks[rock_index % rocks.length]
  rock_index += 1

  highest_rock, gust_index = place_rock(rock, highest_rock, chamber, gust_index)
end

puts "Part 1: #{highest_rock}"


top_shapes = {}
top_shape_and_key_to_time = {}
chamber = create_chamber
rock_index = 0
gust_index = 0
highest_rock = 0
time = 0
desired_times = 1000000000000
heights = {}
skipped_height = 0
loop do
  break if time >= desired_times
  rock = rocks[rock_index]
  rock_index = (rock_index + 1) % rocks.length

  highest_rock, gust_index = place_rock(rock, highest_rock, chamber, gust_index)
  heights[time] = highest_rock

  shape = top_shape(highest_rock, chamber)
  key = [rock_index, gust_index]
  top_shapes[key] ||= Set.new

  if top_shapes[key].include?(shape)
    # Now we can repeat the pattern
    previous_time = top_shape_and_key_to_time[[shape, key]]
    skips_per_round = time - previous_time
    remaining_iterations = desired_times - time
    change_in_height_per_iteration = heights[time] - heights[previous_time]
    iterations = remaining_iterations / skips_per_round
    iterations_to_skip = iterations * skips_per_round
    skipped_height += change_in_height_per_iteration * iterations
    time += iterations_to_skip
  else
    # No skipping possible, so just record the state at this point
    top_shapes[key] << shape
    top_shape_and_key_to_time[[shape, key]] = time
  end

  time += 1
end

puts "Part 2: #{highest_rock + skipped_height}"
