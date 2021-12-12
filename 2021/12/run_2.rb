require 'set'

EDGES = {}
File.readlines('input').map(&:strip).each do |line|
  start, end_ = line.split('-')
  EDGES[start] ||= []
  EDGES[end_] ||= []
  EDGES[start] << end_ unless end_ == 'start'
  EDGES[end_] << start unless start == 'start'
end

def lowercase?(s)
  s.downcase == s
end

PATHS = Set.new
def traverse_with_revisit(node, path)
  if node == 'end'
    PATHS.add("#{path.join(',')},end")
  else
    can_continue = !lowercase?(node) || !path.include?(node) || path.none? { |n| lowercase?(n) && path.count(n) >= 2 }
    if can_continue
      path.push(node)
      EDGES[node].each { |next_node| traverse_with_revisit(next_node, path) }
      path.pop
    end
  end
end

traverse_with_revisit('start', [])
puts PATHS.length
