lines = File.readlines('08/input').map(&:strip).map(&:chars)

nodes_by_name = {}
lines.each_with_index do |row, y|
    row.each_with_index do |col, x|
        if col != '.'
            nodes_by_name[col] ||= []
            nodes_by_name[col] << [x, y]
        end
    end
end

part_1 = nodes_by_name.flat_map do |name, nodes|
    nodes[0..-1].each_with_index.flat_map do |node_1, i|
        nodes[i+1..].flat_map do |node_2|
            diff_x, diff_y = node_2[0] - node_1[0], node_2[1] - node_1[1]
            [[node_1[0] - diff_x, node_1[1] - diff_y], [node_2[0] + diff_x, node_2[1] + diff_y]]
        end
    end
end.uniq.count do |x, y|
    x >= 0 && x < lines[0].count && y >= 0 && y < lines.count
end
puts "Part 1: #{part_1}"

antinodes_2 = Set.new
nodes_by_name.each do |name, nodes|
    nodes[0..-1].each_with_index do |node_1, i|
        nodes[i+1..].each do |node_2|
            diff_x, diff_y = node_2[0] - node_1[0], node_2[1] - node_1[1]

            # In the direction from node_1 to node_2
            i, x, y = 0, *node_1
            while x >= 0 && x < lines[0].count && y >= 0 && y < lines.count
                antinodes_2 << [x, y]
                i, x, y = i+1, node_1[0] + i*diff_x, node_1[1] + i*diff_y
            end

            # In the direction from node_2 to node_1
            i, x, y = 0, *node_1
            while x >= 0 && x < lines[0].count && y >= 0 && y < lines.count
                antinodes_2 << [x, y]
                i, x, y = i+1, node_1[0] - i*diff_x, node_1[1] - i*diff_y
            end
        end
    end
end

puts "Part 2: #{antinodes_2.count}"
