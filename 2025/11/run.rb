lines = File.readlines('11/input').map(&:strip)

connections = lines.map do |line|
  parts = line.split(' ')
  [parts[0][0..-2], parts[1..-1]]
end.to_h

def solve(connections, start_node, end_node, cache = {})
  return 1 if start_node == end_node

  cache[start_node] ||= (connections[start_node] || []).map do |child|
    solve(connections, child, end_node, cache)
  end.sum
end

puts "Part 1: #{solve(connections, 'you', 'out')}"

part_2 =
  solve(connections, 'svr', 'dac') *
  solve(connections, 'dac', 'fft') *
  solve(connections, 'fft', 'out') +
  solve(connections, 'svr', 'fft') *
  solve(connections, 'fft', 'dac') *
  solve(connections, 'dac', 'out')
puts "Part 2: #{part_2}"
