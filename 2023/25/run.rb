lines = File.readlines("25/input").map(&:strip)

$connections = {}

lines.each do |line|
  components = line.gsub(':', '').split(' ')
  first = components[0]
  components[1..-1].each do |second|
    $connections[first] ||= []
    $connections[first] << second
    $connections[second] ||= []
    $connections[second] << first
  end
end

def deep_dup(hash)
  result = {}
  hash.each do |k, v|
    result[k] = v.dup
  end
  result
end

def to_path(coming_from, end_component)
  result = []
  while coming_from[end_component]
    result << [coming_from[end_component], end_component]
    end_component = coming_from[end_component]
  end
  result.reverse
end

def add_connection(from, to, local_connections)
  local_connections[from] << to
  local_connections[to] << from
end

def remove_connection(from, to, local_connections)
  local_connections[from].delete(to)
  local_connections[to].delete(from)
end

def eliminate_path(path, local_connections)
  path.each { |from, to| remove_connection(from, to, local_connections) }
end

def reinstate_path(path, local_connections)
  path.each { |from, to| add_connection(from, to, local_connections) }
end

def path_between(start_component, end_component, local_connections)
  seen = [start_component].to_set
  queue = [start_component]
  coming_from = {}
  last_visited_component = nil
  while queue.any?
    new_queue = []
    queue.each do |component|
      last_visited_component = component
      connections = local_connections[component]
      connections.each do |other_component|
        if !seen.include?(other_component)
          coming_from[other_component] = component
          if other_component == end_component
            return to_path(coming_from, end_component)
          end
          seen << other_component
          new_queue << other_component
        end
      end
    end
    queue = new_queue
  end

  nil
end

def find_important_parts_of_path(path, start_component, end_component, local_connections)
  important_parts_of_path = []
  path.each do |from, to|
    remove_connection(from, to, local_connections)
    if !path_between(start_component, end_component, local_connections)
      important_parts_of_path << [from, to]
    end
    add_connection(from, to, local_connections)
  end
  important_parts_of_path
end

def find_most_distant_component(start_component)
  local_connections = deep_dup($connections)

  seen = [start_component].to_set
  queue = [start_component]
  coming_from = {}
  last_visited_component = nil
  while queue.any?
    new_queue = []
    queue.each do |component|
      last_visited_component = component
      seen << component
      connections = local_connections[component]
      connections.each do |other_component|
        if !seen.include?(other_component)
          coming_from[other_component] = component
          new_queue << other_component
        end
      end
    end
    queue = new_queue
  end

  last_visited_component
end

def visit(start_component, local_connections)
  seen = [start_component].to_set
  queue = [start_component]
  while queue.any?
    new_queue = []
    queue.each do |component|
      seen << component
      local_connections[component].each do |other_component|
        if !seen.include?(other_component)
          new_queue << other_component
        end
      end
    end
    queue = new_queue
  end

  seen
end

def solve(from, to)
  connections = deep_dup($connections)
  path1 = path_between(from, to, connections)
  eliminate_path(path1, connections)
  path2 = path_between(from, to, connections)
  eliminate_path(path2, connections)
  path3 = path_between(from, to, connections)
  raise "No path3 found" unless path3

  important_parts_3 = find_important_parts_of_path(path3, from, to, connections)
  return false unless important_parts_3.count == 1
  important_part_3 = important_parts_3.first
  remove_connection(important_part_3.first, important_part_3.last, connections)
  reinstate_path(path2, connections)

  important_parts_2 = find_important_parts_of_path(path2, from, to, connections)
  return false unless important_parts_2.count == 1
  important_part_2 = important_parts_2.first
  remove_connection(important_part_2.first, important_part_2.last, connections)
  reinstate_path(path1, connections)

  important_parts_1 = find_important_parts_of_path(path1, from, to, connections)
  return false unless important_parts_1.count == 1
  important_part_1 = important_parts_1.first
  remove_connection(important_part_1.first, important_part_1.last, connections)

  size1, size2 = visit(from, connections).count, visit(to, connections).count
  return false if size1 + size2 != $connections.keys.count
  puts "Solution: #{size1} * #{size2} = #{size1 * size2}"
  exit
end

$connections.keys.each do |from|
  to = find_most_distant_component(from)
  solve(from, to)
end
