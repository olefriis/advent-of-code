require 'set'

PATHS = {}
File.readlines('input').map(&:strip).each do |line|
  start, end_ = line.split('-')
  PATHS[start] ||= []
  PATHS[end_] ||= []
  PATHS[start] << end_
  PATHS[end_] << start
end

def simple_paths_from(node, visited)
  return 1 if node == 'end'
  return 0 if node.downcase == node && visited.include?(node)
  visited.add(node)
  result = (PATHS[node] || []).map do |next_node|
    simple_paths_from(next_node, visited)
  end.sum
  visited.delete(node)
  result
end

def paths_with_revisit(node, visited, node_to_revisit, revisited)
  if node == 'end'
    return 1 if revisited && visited.include?(node_to_revisit)
    return 0 # We didn't revisit the node we should have revisited
  end

  if node_to_revisit == node && !revisited
    # Don't add node to visited, but try another round, now _not_ revisiting the 'revisit' node
    return (PATHS[node] || []).map do |next_node|
      paths_with_revisit(next_node, visited, node_to_revisit, true)
    end.sum
  end

  return 0 if node.downcase == node && visited.include?(node)
  visited << node
  result = (PATHS[node] || []).map do |next_node|
    paths_with_revisit(next_node, visited, node_to_revisit, revisited)
  end.sum
  visited.delete(node)
  result
end

simple_paths = simple_paths_from('start', Set.new)
revisiting_paths = PATHS
  .keys
  .filter { |node| node.downcase == node && !['start', 'end'].include?(node) }
  .map { |node| paths_with_revisit('start', Set.new, node, false) }
  .sum

puts simple_paths + revisiting_paths
