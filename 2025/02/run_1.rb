lines = File.readlines('02/input').map(&:strip)

def invalid?(id)
  id.length.even? && id[0, id.length / 2] == id[id.length / 2, id.length / 2]
end

part_1 = 0
lines.first.split(',').each do |ids|
  start_at, end_at = ids.split('-').map(&:to_i)

  start_at.upto(end_at) do |id|
    id_str = id.to_s
    if invalid?(id_str)
      puts "Invalid: #{id_str}"
      part_1 += id
    end
  end
end

puts part_1