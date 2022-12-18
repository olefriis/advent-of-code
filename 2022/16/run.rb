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

non_zero_valves = FLOWS.keys.select {|valve| FLOWS[valve] > 0}

DISTANCES = {}
FLOWS.keys.each do |valve|
  distances = {}
  visited, edge, next_edge = Set.new, Set.new, Set.new
  visited << valve
  edge << valve
  distance = 0
  while edge.any?
    distance += 1
    edge.each do |edge_valve|
      CONNECTIONS[edge_valve].each do |other_valve|
        next if visited.include?(other_valve)
        distances[other_valve] = distance
        next_edge << other_valve
        visited << other_valve
      end
    end

    edge = next_edge
    next_edge = Set.new
  end

  DISTANCES[valve] = distances
end

def visit(valve, relevant_valves, minutes_left, opened, released_pressure_so_far)
  released_pressure_so_far += FLOWS[valve] * minutes_left

  max_released = released_pressure_so_far
  # Try to see if we can open any other valves
  (relevant_valves - opened).each do |other_valve|
    distance = DISTANCES[valve][other_valve]
    next if minutes_left - distance - 1 < 1 # No point if we don't have time to open the valve _and_ let it release pressure

    opened << other_valve
    released = visit(other_valve, relevant_valves, minutes_left - distance - 1, opened, released_pressure_so_far)
    max_released = [max_released, released].max
    opened.delete(other_valve)
  end

  max_released
end

part1 = visit('AA', non_zero_valves, 30, [], 0)
puts "Part 1: #{part1}"

part2 = 1.upto(non_zero_valves.length / 2).map do |number_of_valves_for_me|
  puts "Iterating: #{number_of_valves_for_me}"
  non_zero_valves.combination(number_of_valves_for_me).map do |my_valves|
    valves_for_elephant = non_zero_valves - my_valves
    visit('AA', my_valves, 26, [], 0) + visit('AA', valves_for_elephant, 26, [], 0)
  end.max
end.max
puts "Part 2: #{part2}"
