lines = File.readlines('02/input').map(&:strip)

def invalid_1?(id)
  id.length.even? && id[0, id.length / 2] == id[id.length / 2, id.length / 2]
end

def invalid_2?(id)
  1.upto(id.length / 2).any? do |chunk_length|
    chunk = id[0, chunk_length]
    id == chunk * (id.length / chunk_length)
  end
end

part_1, part_2 = 0, 0
lines.first.split(',').each do |ids|
  start_at, end_at = ids.split('-').map(&:to_i)

  start_at.upto(end_at) do |id|
    id_str = id.to_s
    part_1 += id if invalid_1?(id_str)
    part_2 += id if invalid_2?(id_str)
  end
end

puts "Part 1: #{part_1}"
puts "Part 2: #{part_2}"
