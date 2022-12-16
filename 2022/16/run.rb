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


def calculate_distance_to_remaining_valves(current_valve, opened_valves)
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

  distances
end

@best_pressure = nil
def check_best_pressure(pressure)
  if !@best_pressure || pressure > @best_pressure
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
opened = Set.new
visit('AA', 1, opened, 0)
puts "Part 1: #{@best_pressure}"
