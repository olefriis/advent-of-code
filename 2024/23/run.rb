input = File.readlines('23/input').map(&:strip)

$connections = Hash.new
input.each do |connection|
    a, b = connection.split('-')
    $connections[a] ||= []
    $connections[a] << b
    $connections[b] ||= []
    $connections[b] << a
end

three_node_groups = Set.new
$connections.keys.each do |start_node|
    connected_nodes = $connections[start_node]
    connected_nodes.each do |connected_node|
        ($connections[connected_node] - [start_node]).each do |other_connected_node|
            next unless $connections[other_connected_node].include?(start_node)
            group = Set.new([start_node, connected_node, other_connected_node])
            next if group.size != 3
            three_node_groups << group
        end
    end
end

part_1 = 0
three_node_groups.each do |group|
    part_1 += 1 if group.any? { |n| n.include?('t') }
end
puts "Part 1: #{part_1}"

groups = Set.new
$connections.keys.each do |node|
    conns = $connections[node]
    (conns.length).downto(1) do |attempted_size|
        found_one = false
        conns.combination(attempted_size) do |combination|
            # combination does NOT include node, so it's one element less than the whole cluster
            nodes_in_cluster = combination + [node]
            valid = combination.all? do |connected_node|
                ($connections[connected_node] & nodes_in_cluster).length  == combination.length # It will not include itself
            end
            if valid
                found_one = true
                groups << Set.new(nodes_in_cluster)
            end
        end
        break if found_one
    end
end

big_group = groups.max_by(&:length)
puts big_group.to_a.sort.join(',')
