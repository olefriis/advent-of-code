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

# WRONG: y34 AND x34 -> z34
#connections.delete('z34')

def nodes_from_to(last_node)
    result = Set.new
    0.upto(last_node) do |i|
        result << to_node('x', i)
        result << to_node('y', i)
    end
    result
end

def solve(values, connections)
    remaining_values = connections.keys - values.keys
    feeding_into = {}
    values.keys.each { feeding_into[_1] = Set.new([_1]) }
    until remaining_values.empty?
        found = []
        remaining_values.each do |node|
            a, op, b = *connections[node]
            val_a, val_b = values[a], values[b]
            next unless values[a] && values[b]
            feeding_into[node] = feeding_into[a] + feeding_into[b] + [node]

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
        return nil if found.empty?
        remaining_values -= found
    end

    feeding_into
end

#part_1 = 0
#solved_values = solve(values, connections)
#solved_values.keys.filter { _1.start_with?('z') }.sort.reverse.each do |z_node|
#    part_1 *= 2
#    part_1 += solved_values[z_node] == '1' ? 1 : 0
#end
#puts "Part 1: #{part_1}"

def to_node(prefix, number)
    number < 10 ? "#{prefix}0#{number}" : "#{prefix}#{number}"
end

def set_input(a, b)
    result = {}
    0.upto(44) do |i|
        result[to_node('x', i)] = a % 2 == 1 ? '1' : '0'
        result[to_node('y', i)] = b % 2 == 1 ? '1' : '0'
        a /= 2 
        b /= 2 
    end
    result
end

def parse_output(values)
    result = 0
    values.keys.filter { _1.start_with?('z') }.sort.reverse.each do |z_node|
        result *= 2
        result += values[z_node] == '1' ? 1 : 0
    end
    result
end

# For digit 44: "bvb", "tfg", "bwp", "z45", "z44"

def swap(connections, a, b)
    old_b = connections[b]
    connections[b] = connections[a]
    connections[a] = old_b
end

require 'pry'

def check(connections, input_1, input_2, bits)
    expected_result = input_1 + input_2
    values = set_input(input_1 << (bits-1), input_2 << (bits-1))
    feeding_into = solve(values, connections)
    return [false, feeding_into] unless feeding_into

    result = parse_output(values)
    relevant_result = result >> (bits-1)
    [relevant_result == expected_result, feeding_into]
end

def check_connections(connections)
    1.upto(35) do |bits|
        #matches, feeding_into = *check(connections, 1, 1, bits)
        #return [bits, feeding_into] if !matches
        #matches, feeding_into = *check(connections, 1, 0, bits)
        #return [bits, feeding_into] if !matches
        #matches, feeding_into = *check(connections, 0, 1, bits)
        #return [bits, feeding_into] if !matches


        matches, feeding_into = *check(connections, 25, 15, bits)
        return [bits, feeding_into] if !matches
    end
    puts "Made it to 44!"
    return [44, nil]
end

swap(connections, 'z10', 'mkk')

#Possible: fhq <-> qbw: 26
#Possible: z14 <-> qbw: 26
#swap(connections, 'fhq', 'qbw')
swap(connections, 'z14', 'qbw')

#Possible: cvp <-> wjb: 34
swap(connections, 'cvp', 'wjb')

#Possible: z34 <-> mpd: 44
#Possible: z34 <-> wcb: 44
#swap(connections, 'z34', 'mpd')
swap(connections, 'z34', 'wcb')

swaps = ['z10', 'mkk', 'z14', 'qbw', 'cvp', 'wjb', 'z34', 'wcb']
puts "Part 2: #{swaps.sort.join(',')}"
exit

initial_conditions = check_connections(connections)
puts "Initial: #{initial_conditions.first}"
exit

feeding_into = initial_conditions.last
relevant_feeding_into = (feeding_into['z33'] + feeding_into['z34'] + feeding_into['z35']).uniq
node_1s_to_test = relevant_feeding_into - feeding_into['z32'].to_a
node_2s_to_test = connections.keys.to_a

#binding.pry

puts "Need to test #{node_1s_to_test.count * node_2s_to_test.count} combinations"
iterations = 0
node_1s_to_test.each do |node_1|
    node_2s_to_test.each do |node_2|
        puts iterations if iterations %1000 == 0
        swap(connections, node_1, node_2)

        new_value, _ = *check_connections(connections)
        puts "Possible: #{node_1} <-> #{node_2}: #{new_value}" if new_value > 34

        swap(connections, node_1, node_2)
        iterations += 1
    end
end

exit

wrong_end_connections = []
connections.keys.filter { _1.start_with?('z') }.each do |node|
    operation = connections[node]
    if operation[1] != 'XOR'
        puts "Wrong calculation for #{node}: #{operation}" unless 
        wrong_end_connections << node
    end
end
wrong_end_connections.sort!
p wrong_end_connections

potential_other_connections = []
connections.keys.filter { !_1.start_with?('z') }.each do |node|
    operation = connections[node]
    if operation[1] == 'XOR'
        potential_other_connections << node
    end
end
puts "Potential other connections: #{potential_other_connections.count}"

#swap(connections, 'z10', 'mkk')
#swap(connections, 'z14', 'qbw')
#swap(connections, 'z14', 'z15')
#swap(connections, 'cvp', 'wjb') # Maybe? Looks wrong at x25, y25
# Possibility: wjb <-> cvp - 34
# Possibility: pnm <-> cvp - 34
# Possibility: cvp <-> wjb - 34
# Possibility: cvp <-> pnm - 34
#swap(connections, 'pnm', 'cvp')


#potential_other_connections -= ['mkk']#, 'qbw']
# z34 is obviously wrong

puts "To start with: #{check_connections(connections)}"

#node_1 = 'z26'
#connections.keys.each do |node_2|
#    swap(connections, node_1, node_2)
#    conns = check_connections(connections)
#    puts "Possibility: #{node_1} <-> #{node_2} - #{conns}" if conns && conns > 14
#    #puts "#{other_connection}: #{check_connections(connections)}"
#    swap(connections, node_1, node_2)
#end

iterations = 0
nodes = connections.keys
puts "Total of #{nodes.count ** 4}"
nodes.each do |swap1|
    swap(connections, wrong_end_connections[0], swap1)

    nodes.each do |swap2|
        next if swap2 == swap1
        swap(connections, wrong_end_connections[1], swap2)

        nodes.each do |swap3|
            next if swap3 == swap1 || swap3 == swap2
            swap(connections, wrong_end_connections[2], swap3)

            nodes.each do |swap4|
                next if swap4 == swap1 || swap4 == swap2 || swap4 == swap1
                swap(connections, wrong_end_connections[2], swap3)

                puts iterations if iterations % 1000 == 0

                conns = check_connections(connections)
                if conns && conns > 42
                    puts "Got it with #{swap1} - #{swap2} - #{swap3} - #{swap4}"
                    exit
                end
                iterations += 1

                swap(connections, wrong_end_connections[2], swap4)
            end

            swap(connections, wrong_end_connections[2], swap3)
        end

        swap(connections, wrong_end_connections[1], swap2)
    end

    swap(connections, wrong_end_connections[0], swap1)
end

#p values