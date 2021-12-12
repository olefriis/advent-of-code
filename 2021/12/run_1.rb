require 'set'

lines = File.readlines('input').map(&:strip)
PATHS = {}
lines.each do |line|
  start, end_ = line.split('-')
  PATHS[start] ||= []
  PATHS[end_] ||= []
  PATHS[start] << end_
  PATHS[end_] << start
end

def number_of_paths_from(node, visited)
  return 1 if node == 'end'
  return 0 if node.downcase == node && visited.include?(node)
  visited.add(node)
  result = (PATHS[node] || []).map do |next_node|
    number_of_paths_from(next_node, visited.clone)
  end.sum
  visited.delete(node)
  result
end

puts number_of_paths_from('start', Set.new)
