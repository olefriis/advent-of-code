input = File.readlines("15/input").map(&:strip).join

groups = input.split(',')

def h(group)
  result = 0
  group.chars.each do |char|
    result += char.ord
    result *= 17
    result %= 256
  end
  result
end

part1 = groups.map { |group| h(group) }.sum
puts "Part 1: #{part1}"

def perform(group, boxes)
  if group.end_with?('-')
    label = group[0..-2]
    box = boxes[h(label)]
    index = box.index {|l, _focal_length| l == label }
    box.delete_at(index) if index
  elsif group.include?('=')
    label, focal_length = group.split('=')
    focal_length = focal_length.to_i
    box = boxes[h(label)]
    index = box.index {|l, _focal_length| l == label }
    if index
      box[index][1] = focal_length
    else
      box << [label, focal_length]
    end
  else
    raise "Unknown group: #{group}"
  end
end

boxes = 256.times.map { [] }
groups.each { |group| perform(group, boxes) }

part2 = boxes.each_with_index.map do |box, index|
  box.each_with_index.map do |contents, index2|
    focal_length = contents[1]
    contribution = (index+1) * focal_length * (index2+1)
    contribution
  end.sum
end.sum

puts "Part 2: #{part2}"
