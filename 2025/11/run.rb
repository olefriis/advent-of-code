lines = File.readlines('11/input').map(&:strip)

connections = {}
lines.each do |line|
  parts = line.split(' ')
  start = parts[0][0..-2]
  connections[start] = parts[1..-1].uniq
end

def solve(connections, start_at, end_at, debug=false)
  number_of_connections_leading_in = {}
  number_of_connections_leading_in[start_at] = 1
  current_edge = [start_at].to_set
  while !current_edge.empty?
    next_edge = Set.new
    previous_leading_in = number_of_connections_leading_in.dup
    current_edge.each do |node|
      (connections[node] || []).each do |child|
        number_of_connections_leading_in[child] ||= 0
        number_of_connections_leading_in[child] += previous_leading_in[node]
        next_edge << child
      end
    end
    current_edge = next_edge
  end

  result = number_of_connections_leading_in[end_at] || 0
  puts "#{start_at} -> #{end_at}: #{result}"
  result
end

CachedResult = Struct.new(:node, :has_visited_fft, :has_visited_dac)
def solve_2(connections, current_node, has_visited_fft, has_visited_dac, cache = {})
  cache_key = CachedResult.new(current_node, has_visited_fft, has_visited_dac)
  return cache[cache_key] if cache.key?(cache_key)

  return 1 if current_node == 'out' && has_visited_fft && has_visited_dac
  return 0 if current_node == 'out'

  total_paths = 0
  (connections[current_node] || []).each do |child|
    new_has_visited_fft = has_visited_fft || (child == 'fft')
    new_has_visited_dac = has_visited_dac || (child == 'dac')

    total_paths += solve_2(connections, child, new_has_visited_fft, new_has_visited_dac, cache)
  end

  cache[cache_key] = total_paths
  total_paths
end

puts "Part 1: #{solve(connections, 'you', 'out')}"

def from_to_without(connections, to, without)
  result = connections.dup
  # Ensure we're not proceeding after our destination
  result[to] = []
  # Also, let's cut the inputs to the nodes we don't want to visit
  result.keys.each do |key|
    result[key] = result[key] - without
  end
  #puts "Connections to #{to} without #{without}: #{result.inspect}"
  result
end

from_you_to_dac_without_fft_and_you = from_to_without(connections, 'dac', ['fft', 'svr'])
from_dac_to_fft_without_dac_and_you = from_to_without(connections, 'fft', ['dac', 'svr'])
from_fft_to_you_without_dac_and_fft = from_to_without(connections, 'svr', ['dac', 'fft'])

part_2_option_1 =
  solve(from_you_to_dac_without_fft_and_you, 'svr', 'dac') *
  solve(from_dac_to_fft_without_dac_and_you, 'dac', 'fft') *
  solve(from_fft_to_you_without_dac_and_fft, 'fft', 'out')
puts "Part 2, visiting dac, then fft: #{part_2_option_1}"

from_you_to_fft_without_dac_and_you = from_to_without(connections, 'fft', ['dac', 'svr'])
from_fft_to_dac_without_dac_and_fft = from_to_without(connections, 'dac', ['fft', 'svr'])
from_dac_to_you_without_fft_and_you = from_to_without(connections, 'svr', ['dac', 'fft'])

part_2_option_2 =
  solve(from_you_to_fft_without_dac_and_you, 'svr', 'fft') *
  solve(from_fft_to_dac_without_dac_and_fft, 'fft', 'dac') *
  solve(from_dac_to_you_without_fft_and_you, 'dac', 'out')
puts "Part 2, visiting fft, then dac: #{part_2_option_2}"

# Creates the wrong answer, for some reason :shrug:
#puts "Part 2: #{part_2_option_1 + part_2_option_2}"

puts "Part 2, take 2: #{solve_2(connections, 'svr', false, false)}"
