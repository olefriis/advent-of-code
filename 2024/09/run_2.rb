input = File.readlines('09/input').map(&:strip).first.chars.map(&:to_i)

layout = []
current_id = 0
0.upto(input.length / 2) do |i|
    size, free_space = input[i*2], input[i*2 + 1]

    layout << [current_id, size]
    layout << [nil, free_space] unless free_space.nil? || free_space == 0

    current_id += 1
end
current_id -= 1

def compact(layout)
    moved = true
    while moved
        moved = false
        0.upto(layout.count - 2) do |i|
            block, next_block = layout[i], layout[i+1]
            if block[0].nil? && next_block[0].nil?
                block[1] = block[1] + next_block[1]
                layout = layout[0..i] + layout[i+2..]
                moved = true
                break
            end
        end
    end
    layout
end

while current_id > 0
    block_index = layout.index { |block| block[0] == current_id }
    block = layout[block_index]
    size = block[1]

    0.upto(block_index - 1) do |i|
        potential_block = layout[i]
        potential_id, potential_size = *potential_block
        if potential_id.nil? && potential_size >= size
            potential_block[0] = current_id
            potential_block[1] = size

            block[0] = nil

            if potential_size > size
                # Add new empty space
                layout = layout[0..i] + [[nil, potential_size - size]] + layout[i+1..]
            end

            break
        end
    end

    layout = compact(layout)

    current_id -= 1
end

position, part_2 = 0, 0
layout.each do |id, size|
    while size > 0
        part_2 += id * position unless id.nil?
        position += 1
        size -= 1
    end
end

puts "Part 2: #{part_2}"
