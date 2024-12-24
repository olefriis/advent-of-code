initial_values, wirings = File.read('24/input').split("\n\n")

values = {}
nodes_to_calculate = Set.new
initial_values.lines.map(&:strip).each do |line|
    line =~ /^(.*): (0|1)$/ or raise "Could not parse line #{line}"
    values[$1] = $2
end

connections = {}
wirings.lines.map(&:strip).each do |line|
    line =~ /(.*) (.*) (.*) -> (.*)/ or raise "Could not parse line #{line}"
    connections[$4] = [$1, $2, $3]
    nodes_to_calculate << $4
end

remaining_values = connections.keys - values.keys
until remaining_values.empty?
    found = []
    remaining_values.each do |node|
        a, op, b = *connections[node]
        val_a, val_b = values[a], values[b]
        next unless values[a] && values[b]
        
        result = case op
        when 'AND'
            val_a == '1' && val_b == '1' ? '1' : '0'
        when 'OR'
            val_a == '1' || val_b == '1' ? '1' : '0'
        when 'XOR'
            val_a != val_b ? '1' : '0'
        else
            raise "Unknown operation: #{op}"
        end
        values[node] = result
        found << node
    end
    remaining_values -= found
end

part_1 = 0
values.keys.filter { _1.start_with?('z') }.sort.reverse.each do |z_node|
    part_1 *= 2
    part_1 += values[z_node] == '1' ? 1 : 0
end
puts "Part 1: #{part_1}"

#p values