Configuration = Struct.new(:hallway, :room1, :room2, :room3, :room4) do
  def valid?
    # No amphipod should be above any room
    hallway[2] == nil && hallway[4] == nil && hallway[6] == nil && hallway[8] == nil
  end

  def done?
    # All rooms should have the same kind of amphipod
    room1[0].type == room1[1].type && room1[0].type == room1[2].type && room2[0].type == room2[1].type && room3[0].type == room3[0].type
  end
end

# The configuration consists of an array of each of the 4 rooms, and finally an array for the hallway

# Starting configuration - test input
test_input_part1 = [
  ['B', 'A'],
  ['C', 'D'],
  ['B', 'C'],
  ['D', 'A'],
  [nil] * 11
]
test_input_part2 = [
  ['B', 'D', 'D', 'A'],
  ['C', 'C', 'B', 'D'],
  ['B', 'B', 'A', 'C'],
  ['D', 'A', 'C', 'A'],
  [nil] * 11
]

# Starting configuration - puzzle input
puzzle_input_part1 = [
  ['D', 'D'],
  ['B', 'A'],
  ['C', 'B'],
  ['C', 'A'],
  [nil] * 11
]
puzzle_input_part2 = [
  ['D', 'D', 'D', 'D'],
  ['B', 'C', 'B', 'A'],
  ['C', 'B', 'A', 'B'],
  ['C', 'A', 'C', 'A'],
  [nil] * 11
]
input_configuration = puzzle_input_part2

winning_configuration_part1 = [
  ['A', 'A'],
  ['B', 'B'],
  ['C', 'C'],
  ['D', 'D'],
  [nil] * 11
]
winning_configuration_part2 = [
  ['A', 'A', 'A', 'A'],
  ['B', 'B', 'B', 'B'],
  ['C', 'C', 'C', 'C'],
  ['D', 'D', 'D', 'D'],
  [nil] * 11
]

energy_to_configuration = {}
ROOM_DESTINATIONS = ['A', 'B', 'C', 'D']
ROOM_POSITIONS = [2, 4, 6, 8]
ENERGY_FOR_EACH_STEP = {
  'A' => 1,
  'B' => 10,
  'C' => 100,
  'D' => 1000
}
CONFIGURATIONS_TO_ENERGY = {
  input_configuration => 0
}
AMPHIPOD_ROOM_DESTINATIONS = {
  'A' => 0,
  'B' => 1,
  'C' => 2,
  'D' => 3
}

CONFIGURATIONS_TO_CONSIDER = [input_configuration]

def show_configuration(configuration)
  puts '#############'
  puts '#' + (configuration[-1].map { |amp| amp || '.' }.join) + '#'
  configuration[0].length.times do |i|
    print '   '
    configuration[0..3].each do |room|
      print room[i] || '.'
      print ' '
    end
    puts ''
  end
end

def available_hallway_positions(room_position, hallway)
  result = []
  room_position.downto(0) do |i|
    break if hallway[i] # Something is blocking us
    result << i if !ROOM_POSITIONS.include?(i) # We must not wait outside of a room
  end
  room_position.upto(10) do |i|
    break if hallway[i] # Something is blocking us
    result << i if !ROOM_POSITIONS.include?(i) # We must not wait outside of a room
  end
  result
end

def try_configuration(configuration, energy_for_configuration)
  # Each uppermost amphipod in each room can move to the hallway. This only makes sense for amphipods that are not
  # already at the right position.
  0.upto(3).each do |room_index|
    room = configuration[room_index]
    room_position = ROOM_POSITIONS[room_index]
    room_destination = ROOM_DESTINATIONS[room_index]
    all_amphipods_in_room_at_rest = room.all? { |amp| !amp || amp == room_destination }
    next if all_amphipods_in_room_at_rest

    uppermost_amphipod_position = room.index { |amp| amp }
    amphipod = room[uppermost_amphipod_position]

    # Create new room where the amphipod has moved away
    new_room = room.dup
    new_room[uppermost_amphipod_position] = nil

    available_hallway_positions = available_hallway_positions(room_position, configuration.last)
    available_hallway_positions.each do |hallway_position|
      # First, the amphipod needs to come up from the room to the hallway. That is the room position + 1
      steps = uppermost_amphipod_position + 1
      # Then it needs to move to the hallway position
      steps += (hallway_position - room_position).abs
      energy_for_steps = steps * ENERGY_FOR_EACH_STEP[amphipod]
      new_energy = energy_for_configuration + energy_for_steps

      # Create new hallway where the amphipod is at its destination
      new_hallway = configuration.last.dup
      new_hallway[hallway_position] = amphipod

      # Create new configuration with all of this
      new_configuration = configuration.dup
      new_configuration[room_index] = new_room
      new_configuration[4] = new_hallway

      # Check if this configuration has already been calculated
      existing_energy = CONFIGURATIONS_TO_ENERGY[new_configuration]
      if !existing_energy || existing_energy > new_energy
        CONFIGURATIONS_TO_ENERGY[new_configuration] = new_energy
        # It makes sense to consider this configuration
        CONFIGURATIONS_TO_CONSIDER << new_configuration
      end
    end
  end

  # Each amphipod in the hallway can move to its room.
  hallway = configuration.last
  0.upto(10) do |hallway_index|
    amphipod = hallway[hallway_index]
    next unless amphipod

    destination_room_index = AMPHIPOD_ROOM_DESTINATIONS[amphipod]
    destination_room = configuration[destination_room_index]
    destination_room_position = ROOM_POSITIONS[destination_room_index]
    other_amphipod_blocking = false
      # If something is in the way, we can't move the amphipod
      if destination_room_position > hallway_index
      (hallway_index + 1).upto(destination_room_position).each do |i|
        other_amphipod_blocking = true if hallway[i]
      end
    else
      (hallway_index - 1).downto(destination_room_position).each do |i|
        other_amphipod_blocking = true if hallway[i]
      end
    end
    next if other_amphipod_blocking

    # If that room is occupied by something else than this type of amphipod, we won't move
    room_only_occupied_with_proper_amphipods = destination_room.all? { |amp| !amp || amp == amphipod }
    next unless room_only_occupied_with_proper_amphipods

    # Create new hallway where the amphipod has moved away
    new_hallway = hallway.dup
    new_hallway[hallway_index] = nil

    # Create new room where the amphipod has moved to
    new_room = destination_room.dup

    # A bit rude... there's probably a more elegant way of doing this
    available_slot = 0
    new_room.each_with_index do |amp, i|
      available_slot = i if !amp
    end
    new_room[available_slot] = amphipod

    # Create new configuration with all of this
    new_configuration = configuration.dup
    new_configuration[4] = new_hallway
    new_configuration[destination_room_index] = new_room

    # First, the amphipod needs to walk from its position to its room entrance
    steps = (hallway_index - destination_room_position).abs
    # Then it needs to move to its final destination in the room
    steps += available_slot + 1
    energy_for_steps = steps * ENERGY_FOR_EACH_STEP[amphipod]
    new_energy = energy_for_configuration + energy_for_steps

    # Check if this configuration has already been calculated
    existing_energy = CONFIGURATIONS_TO_ENERGY[new_configuration]
    if !existing_energy || existing_energy > new_energy
      CONFIGURATIONS_TO_ENERGY[new_configuration] = new_energy
      # It makes sense to consider this configuration
      CONFIGURATIONS_TO_CONSIDER << new_configuration
    end
  end
end

while CONFIGURATIONS_TO_CONSIDER.length > 0
  configuration = CONFIGURATIONS_TO_CONSIDER.shift
  energy_for_configuration = CONFIGURATIONS_TO_ENERGY[configuration]
  try_configuration(configuration, energy_for_configuration)
end

puts "We have #{CONFIGURATIONS_TO_ENERGY.length} configurations"
#CONFIGURATIONS_TO_ENERGY.each do |configuration, energy|
#  puts "\nEnergy: #{energy}:"
#  show_configuration(configuration)
#end

puts "Winning configuration takes #{CONFIGURATIONS_TO_ENERGY[winning_configuration_part2]} energy"
