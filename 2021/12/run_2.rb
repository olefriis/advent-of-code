EDGES = {}
File.readlines('input').map(&:strip).each do |line|
  start, end_ = line.split('-')
  EDGES[start] ||= []
  EDGES[end_] ||= []
  EDGES[start] << end_ unless end_ == 'start'
  EDGES[end_] << start unless start == 'start'
end

# Add String#is_lower?
class String
  def is_lower?
    self.downcase == self
  end
end

def paths_with_revisit(node, path)
  return 1 if node == 'end'

  can_continue = !node.is_lower? || !path.include?(node) || path.none? { |n| n.is_lower? && path.count(n) >= 2 }
  return 0 unless can_continue

  path.push(node)
  result = EDGES[node].map { |next_node| paths_with_revisit(next_node, path) }.sum
  path.pop
  result
end

puts paths_with_revisit('start', [])
