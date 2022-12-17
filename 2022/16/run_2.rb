# Much simpler approach to the puzzle, and part 2 also finishes in finite time...

require 'set'
lines = File.readlines('16/input', chomp: true)
FLOWS = {}

initial_connections = {}
lines.each do |line|
  raise "Strange line: #{line}" unless line =~ /Valve (.*) has flow rate=(.*); tunnels? leads? to valves? (.*)/
  valve, flow, other_valves = $1, $2.to_i, $3
  FLOWS[valve] = flow
  initial_connections[valve] = other_valves.split(', ')
end

CONNECTIONS = {}
FLOWS.keys.each do |valve|
  distances = {}
  visited, edge, next_edge = Set.new, Set.new, Set.new
  visited << valve
  edge << valve
  distance = 0
  while edge.any?
    distance += 1
    edge.each do |edge_valve|
      initial_connections[edge_valve].each do |other_valve|
        next if visited.include?(other_valve)
        distances[other_valve] = distance
        next_edge << other_valve
        visited << other_valve
      end
    end

    edge = next_edge
    next_edge = Set.new
  end

  CONNECTIONS[valve] = distances
end

def solve(valves, time)
  paths = [[['AA'], time, 0]]
  max_pressure = 0
  while paths.any?
    new_paths = []
    paths.each do |path|
      visited_valves, time_remaining, pressure = path
      current_valve = visited_valves.last
      max_pressure = [max_pressure, pressure].max
      (valves - visited_valves).each do |next_valve|
        distance = CONNECTIONS[current_valve][next_valve]

        time_remaining_when_valve_is_opened = time_remaining - distance - 1
        next if time_remaining_when_valve_is_opened <= 0

        new_paths << [visited_valves + [next_valve], time_remaining_when_valve_is_opened, pressure + FLOWS[next_valve] * time_remaining_when_valve_is_opened]
      end
    end
    paths = new_paths
  end

  max_pressure
end

relevant_valves = FLOWS.keys.select {|valve| FLOWS[valve] > 0}
puts "Part 1: #{solve(relevant_valves, 30)}"

max_pressure = 0
1.upto(relevant_valves.length / 2) do |number_of_valves_for_me|
  puts "Iterating: #{number_of_valves_for_me}"
  relevant_valves.combination(number_of_valves_for_me).each do |my_valves|
    valves_for_elephant = relevant_valves - my_valves
    pressure = solve(my_valves, 26) + solve(valves_for_elephant, 26)
    max_pressure = [max_pressure, pressure].max
  end
end
puts "Part 2: #{max_pressure}"
