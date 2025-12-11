require 'pry'
lines = File.readlines('11/input').map(&:strip)

connections = {}
lines.each do |line|
  parts = line.split(' ')
  start = parts[0][0..-2]
  connections[start] = parts[1..-1].uniq
end

part_1 = 0
def solve(connections, start_at, end_at, debug=false)
  #puts "Going from #{start_at} to #{end_at}"
  number_of_connections_leading_in = {}
  number_of_connections_leading_in[start_at] = 1
  current_edge = [start_at].to_set
  iterations = 0
  while !current_edge.empty?
    #puts "Current edge: #{current_edge.inspect}" if debug
    iterations += 1
    #binding.pry
    next_edge = [].to_set
    current_edge.each do |node|
      #puts "No connection from #{node}" unless connections.key?(node)
      (connections[node] || []).each do |child|
        number_of_connections_leading_in[child] ||= 0
        number_of_connections_leading_in[child] += number_of_connections_leading_in[node]
        next_edge << child
      end
    end
    current_edge = next_edge
  end

  result = number_of_connections_leading_in[end_at] || 0
  #puts "Result (#{iterations} iterations): #{result}"
  result
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

#puts "All paths from svr to out: #{solve(connections, 'svr', 'out')}"

puts "Part 2: #{part_2_option_1 + part_2_option_2}"

#puts solve(connections, 'svr', 'fft') * solve(connections, 'fft', 'dac') * solve(connections, 'dac', 'out')

#puts "All paths from srv to out: #{solve(connections, 'svr', 'out')}"
#puts "All paths from dac to fft: #{solve(connections, 'dac', 'fft', true)}"
# Not correct: 1581994319578204320 (too high)
