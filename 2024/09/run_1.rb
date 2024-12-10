input = File.readlines('09/input').map(&:strip).first.chars.map(&:to_i)

memory = []
input.each_slice(2).each_with_index do |slice, current_id|
    slice[0].times { memory << current_id }
    (slice[1] || 0).times { memory << nil }
end

part_1, position = 0, 0
until memory.empty?
    id = memory.delete_at(0) || memory.delete_at(-1)
    memory.delete_at(-1) while !memory.empty? && !memory[-1]

    part_1 += position * id
    position += 1
end
puts "Part 1: #{part_1}"
