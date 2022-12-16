require 'pry'
require 'set'
lines = File.readlines('16/input', chomp: true)
FLOWS = {}
CONNECTIONS = {}

lines.each do |line|
  raise "Strange line: #{line}" unless line =~ /Valve (.*) has flow rate=(.*); tunnels? leads? to valves? (.*)/
  valve, flow, other_valves = $1, $2.to_i, $3
  FLOWS[valve] = flow
  CONNECTIONS[valve] = other_valves.split(', ')
end

RELEVANT_VALVES = Set.new(FLOWS.keys.select {|valve| FLOWS[valve] > 0})
DISTANCE_CACHE = {}

def calculate_distance_to_remaining_valves(current_valve, opened_valves)
  cache_key = "#{current_valve}-#{opened_valves.to_a.sort.join('-')}"
  return DISTANCE_CACHE[cache_key] if DISTANCE_CACHE[cache_key]
  return {} if current_valve == '--'

  remaining_valves = RELEVANT_VALVES - opened_valves - [current_valve]
  distances = {}
  visited = Set.new
  edge = Set.new
  edge << current_valve
  next_edge = Set.new
  distance = 0
  while edge.any?
    distance += 1
    edge.each do |valve|
      CONNECTIONS[valve].each do |other_valve|
        next if visited.include?(other_valve)

        distances[other_valve] = distance if remaining_valves.include?(other_valve)
        next_edge << other_valve
        visited << other_valve
      end
    end

    edge = next_edge
    next_edge = Set.new
  end

  DISTANCE_CACHE[cache_key] = distances
  distances
end

@best_pressure = nil
def check_best_pressure(pressure)
  if !@best_pressure || pressure > @best_pressure
    puts "New best pressure: #{pressure}"
    @best_pressure = pressure
  end
end

def pressure_released_per_minute(opened)
  opened.map {|valve| FLOWS[valve]}.sum
end

def visit(valve, minute, opened, released_pressure_so_far)
  check_best_pressure(released_pressure_so_far)

  remaining_valves = calculate_distance_to_remaining_valves(valve, opened)

  # Try to see if we can open any other valves
  remaining_valves.each do |other_valve, distance|
    next if minute + distance > 29 # No point if we don't have time to open the valve _and_ let it release pressure
    released_pressure_while_traveling_and_opening_next_valve = (distance + 1) * pressure_released_per_minute(opened)

    opened << other_valve
    visit(other_valve, minute + distance + 1, opened, released_pressure_so_far + released_pressure_while_traveling_and_opening_next_valve)
    opened.delete(other_valve)
  end

  # Also consider just waiting here
  released_pressure_when_staying = pressure_released_per_minute(opened) * (31 - minute)
  check_best_pressure(released_pressure_so_far + released_pressure_when_staying)
end

def visit2(valve1, to_valve1, traveltime_valve1, valve2, to_valve2, traveltime_valve2, minute, opened, released_pressure_so_far)
  return if minute > 26
  # Ensure that we have a place to go
  if !to_valve1
    remaining_valves = calculate_distance_to_remaining_valves(valve1, opened)
    has_others_to_try_out = false
    remaining_valves.each do |other_valve, distance|
      next if other_valve == to_valve2
      has_others_to_try_out = true
      visit2(to_valve1, other_valve, distance, valve2, to_valve2, traveltime_valve2, minute, opened, released_pressure_so_far)
    end
    if !has_others_to_try_out
      # Cheat... Let us go to somewhere it will never reach
      visit2('--', '--', 1000, valve2, to_valve2, traveltime_valve2, minute, opened, released_pressure_so_far)
    end
    return
  end

  # Ensure the elephant has a place to go
  if !to_valve2
    remaining_valves = calculate_distance_to_remaining_valves(valve2, opened)
    has_others_to_try_out = false
    remaining_valves.each do |other_valve, distance|
      next if other_valve == to_valve1
      has_others_to_try_out = true
      visit2(valve1, to_valve1, traveltime_valve1, to_valve2, other_valve, distance, minute, opened, released_pressure_so_far)
    end
    if !has_others_to_try_out
      # Cheat... Let it go to somewhere it will never reach
      visit2(valve1, to_valve1, traveltime_valve1, '--', '--', 1000, minute, opened, released_pressure_so_far)
    end
    return
  end

  # Let time pass this minute
  minute += 1
  released_pressure_so_far += pressure_released_per_minute(opened)
  check_best_pressure(released_pressure_so_far)

  traveltime_valve1 -= 1
  traveltime_valve2 -= 1

  newly_opened = []

  if traveltime_valve1 == -1
    # We have arrived at the destination valve _and_ spent a minute opening the valve. So now we're out of work.
    newly_opened << to_valve1
    valve1 = to_valve1
    to_valve1 = nil
  end
  if traveltime_valve2 == -1
    # The elephant has arrived at the destination valve _and_ spent a minute opening the valve. So now it's out of work.
    newly_opened << to_valve2
    valve2 = to_valve2
    to_valve2 = nil
  end

  newly_opened.each {|no| opened << no}
  visit2(valve1, to_valve1, traveltime_valve1, valve2, to_valve2, traveltime_valve2, minute, opened, released_pressure_so_far)
  newly_opened.each {|no| opened.delete(no)}
end

#@best_pressure = nil
#visit('AA', 1, Set.new, 0)
#puts "Part 1: #{@best_pressure}"

@best_pressure = nil
visit2('AA', nil, nil, 'AA', nil, nil, 1, Set.new, 0)
puts "Part 2: #{@best_pressure}"

# 2215: Too low