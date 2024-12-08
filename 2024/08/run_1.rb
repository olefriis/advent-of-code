lines = File.readlines('08/input').map(&:strip).map(&:chars)

nodes_by_name = {}

lines.each_with_index do |row, x|
    row.each_with_index do |col, y|
        if col != '.'
            nodes_by_name[col] ||= []
            nodes_by_name[col] << [x, y]
        end
    end
end

antinodes = Set.new
nodes_by_name.each do |name, nodes|
    0.upto(nodes.count-2) do |i|
        node_1 = nodes[i]
        (i+1).upto(nodes.count-1) do |j|
            node_2 = nodes[j]
            diff_x, diff_y = node_2[0] - node_1[0], node_2[1] - node_1[1]
            antinodes << [node_1[0] - diff_x, node_1[1] - diff_y]
            antinodes << [node_2[0] + diff_x, node_2[1] + diff_y]
        end
    end
end

antinodes = antinodes.select do |x, y|
    x >= 0 && x < lines[0].count && y >= 0 && y < lines.count
end

#p antinodes
puts antinodes.count
