EDGES = {}
File.readlines('input').map(&:strip).each do |line|
  start, end_ = line.split('-')
  EDGES[start] ||= []
  EDGES[end_] ||= []
  EDGES[start] << end_
  EDGES[end_] << start
end

def number_of_paths_from(node, visited)
  return 1 if node == 'end'
  return 0 if node.downcase == node && visited.include?(node)
  visited.push(node)
  result = EDGES[node].map { |next_node| number_of_paths_from(next_node, visited) }.sum
  visited.pop
  result
end

puts number_of_paths_from('start', [])
