require 'set'

EDGES = {}
File.readlines('input').map(&:strip).each do |line|
  start, end_ = line.split('-')
  EDGES[start] ||= []
  EDGES[end_] ||= []
  EDGES[start] << end_
  EDGES[end_] << start
end

PATHS = Set.new
def traverse_with_revisit(node, path, visited, has_revisited)
  path.push(node)
  if node == 'end'
    PATHS.add(path.join(','))
  else
    if !has_revisited && node != 'start'
      EDGES[node].each { |next_node| traverse_with_revisit(next_node, path, visited, true) }
    end
    if !visited.include?(node)
      visited.add(node) if node.downcase == node
      EDGES[node].each { |next_node| traverse_with_revisit(next_node, path, visited, has_revisited) }
      visited.delete(node)
    end
  end
  path.pop
end

traverse_with_revisit('start', [], Set.new, false)
puts PATHS.length
