input = File.readlines('09/input').map(&:strip).first.chars.map(&:to_i)

layout = []
input.each_slice(2).each_with_index do |slice, current_id|
    layout << [current_id, slice[0]]
    layout << [nil, slice[1] || 0]
end

current_id = layout[-2][0]
while current_id > 0
    block_index = layout.index { |block| block[0] == current_id }
    current_id -= 1
    block = layout[block_index]
    size = block[1]

    new_index = layout.index { |block| block[0].nil? && block[1] >= size }
    next if new_index.nil? || new_index > block_index

    # Remove the block from its original position
    layout[block_index - 1][1] += size
    layout.delete_at(block_index)

    # Combine empty slots around us
    layout[block_index - 1][1] += layout[block_index][1]
    layout.delete_at(block_index)

    # Move the block to the new position
    layout[new_index][1] -= size
    layout.insert(new_index, [nil, 0], block)
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
