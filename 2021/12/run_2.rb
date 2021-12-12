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

def paths_with_revisit(node, path)
  return 1 if node == 'end'

  can_continue = !lowercase?(node) || !path.include?(node) || path.none? { |n| lowercase?(n) && path.count(n) >= 2 }
  return 0 unless can_continue

  path.push(node)
  result = EDGES[node].map { |next_node| paths_with_revisit(next_node, path) }.sum
  path.pop
  result
end

puts paths_with_revisit('start', [])
