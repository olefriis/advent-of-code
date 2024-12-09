input = File.readlines('09/input').map(&:strip).first.chars.map(&:to_i)

layout = []

current_id = 0
0.upto(input.length / 2) do |i|
    size, free_space = input[i*2], input[i*2 + 1]

    layout << [current_id, size]
    layout << [nil, free_space] unless free_space.nil? || free_space == 0

    current_id += 1
end

resulting_layout = []

while layout.count > 0
    block = layout[0]
    id, size = *block

    if id
        # Let this be, as it already has something in it
        resulting_layout << [id, size]
        layout = layout[1..]
    else
        # Take something from the last block
        last_block = layout[-1]
        last_id, last_size = last_block
        # Remove it if it is empty or has no id
        if last_id.nil? || last_size == 0
            layout = layout[0...-1]
        else
            to_move = [last_size, size].min
            resulting_layout << [last_id, to_move]
            last_block[1] -= to_move
            block[1] -= to_move
            if block[1] == 0
                layout = layout[1..-1]
            end
        end
    end
end

position, part_1 = 0, 0
resulting_layout.each do |id, size|
    while size > 0
        part_1 += id * position
        position += 1
        size -= 1
    end
end

puts "Part 1: #{part_1}"
