input = File.readlines('23/input').map(&:strip)

connections = Hash.new { |hash, key| hash[key] = [] }
input.each do |connection|
    a, b = connection.split('-')
    connections[a] << b
    connections[b] << a
end

three_node_groups = connections.keys.flat_map do |node_1|
    connections[node_1].flat_map do |node_2|
        (connections[node_2] - [node_1]).filter_map do |node_3|
            next unless connections[node_3].include?(node_1)
            group = Set.new([node_1, node_2, node_3])
            group.size == 3 ? group : nil
        end
    end
end.uniq
part_1 = three_node_groups.count { |group| group.any? { _1.include?('t') } }
puts "Part 1: #{part_1}"

def largest_interconnected_group(connections, node)
    initial_connections = connections[node]
    initial_connections.length.downto(1) do |attempted_size|
        initial_connections.combination(attempted_size) do |combination|
            # `combination` does NOT include `node`, so it's one element less than the whole cluster
            nodes_in_cluster = combination + [node]
            valid = combination.all? { (connections[_1] & nodes_in_cluster).length == combination.length }
            return Set.new(nodes_in_cluster) if valid
        end
    end
    raise 'Should not happen - we should at least find a group of size 2'
end

big_groups = connections.keys.map { largest_interconnected_group(connections, _1) }
part_2 = big_groups.max_by(&:length).to_a.sort.join(',')
puts "Part 2: #{part_2}"
