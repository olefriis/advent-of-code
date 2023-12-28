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

def remove_connection(from, to, local_connections)
  local_connections[from].delete(to)
  local_connections[to].delete(from)
end

def eliminate_path(path, local_connections)
  path.each do |from, to|
    local_connections[from].delete(to)
    local_connections[to].delete(from)
  end
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

def number_of_nodes_reachable_from(start_component, local_connections)
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

  seen.count
end

def solve(from, to)
  connections = deep_dup($connections)
  path1 = path_between(from, to, connections)
  eliminate_path(path1, connections)
  path2 = path_between(from, to, connections)
  eliminate_path(path2, connections)
  path3 = path_between(from, to, connections)
  eliminate_path(path3, connections)

  [number_of_nodes_reachable_from(from, connections), number_of_nodes_reachable_from(to, connections)]
end

from = $connections.keys.first
to = find_most_distant_component(from)
size_1, size_2 = solve(from, to)

puts "Part 1: #{size_1 * size_2}"
