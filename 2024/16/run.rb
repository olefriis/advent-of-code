map = File.readlines('16/input').map(&:strip).map(&:chars)

Node = Struct.new(:position, :direction)

DIRECTIONS = [
    [1, 0],
    [-1, 0],
    [0, 1],
    [0, -1]
]

connections = {}
unvisited = Set.new
distances = {}
coming_from = {}
end_nodes = []

# We don't have a real priority queue, so "popping" the unvisited node with the shortest distance will be
# expensive. As a hack, keep a set of only the unvisited that have a distance. This set is much smaller than
# the whole unvisited set, so it speeds up things a bit. Still not perfect though.
unvisited_with_distance = Set.new

map.each_with_index do |row, y|
    row.each_with_index do |col, x|
        next if col == '#'
        nodes = DIRECTIONS.map { |d| Node.new([x, y], d) }
        nodes.each do |node|
            unvisited << node
            distances[node] = 10000000 # Very large
            coming_from[node] = []
        end

        if col == 'S'
            distances[nodes[0]] = 0
            unvisited_with_distance << nodes[0]
        end
        if col == 'E'
            end_nodes = nodes
        end
    end
end

while !unvisited.empty?
    current_node = unvisited_with_distance.min_by { |node| distances[node] }
    current_distance = distances[current_node]
    position = current_node.position
    direction = current_node.direction
    unvisited.delete(current_node)
    unvisited_with_distance.delete(current_node)

    potential_connections = []

    # We can continue our path
    potential_connections << [current_distance + 1, Node.new([position[0] + direction[0], position[1] + direction[1]], direction)]

    # We can turn left
    rotated_left = [direction[1], -direction[0]]
    potential_connections << [current_distance + 1000, Node.new(position, rotated_left)]

    # We can turn right
    rotated_right = [-direction[1], direction[0]]
    potential_connections << [current_distance + 1000, Node.new(position, rotated_right)]

    potential_connections.each do |distance, node|
        next unless unvisited.include?(node)

        if distances[node] > distance
            distances[node] = distance
            coming_from[node] = [current_node]
            unvisited_with_distance << node
        elsif distances[node] == distance
            coming_from[node] << current_node
            unvisited_with_distance << node
        end
    end
end

part_1 = end_nodes.map { |node| distances[node] }.min
puts "Part 1: #{part_1}"

nodes = end_nodes.filter { |node| distances[node] == part_1 }
part_of_path = Set.new
part_of_path << nodes[0].position
while !nodes.empty?
    new_nodes = Set.new

    nodes.each do |node|
        coming_from[node].each do |coming_from_node|
            new_nodes << coming_from_node
        end
    end
    new_nodes.each do |node|
        part_of_path << node.position
    end

    nodes = new_nodes
end
puts "Part 2: #{part_of_path.count}"
