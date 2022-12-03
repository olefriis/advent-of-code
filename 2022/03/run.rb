lines = File.readlines('03/input').map(&:strip).map(&:chars)

def priority(item)
  if item.ord >= 'a'.ord
    item.ord - 'a'.ord + 1
  else
    item.ord - 'A'.ord + 27
  end
end

common_items = lines.map { |line| line[0...line.count/2] & line[line.count/2..-1] }
common_priority_sum = common_items.flatten.map{priority(_1)}.sum
puts "Part 1: #{common_priority_sum}"

groups = lines.each_slice(3).to_a
badges = groups.map { |group| group.inject(&:&) }
badge_sum = badges.flatten.map{priority(_1)}.sum
puts "Part 2: #{badge_sum}"
