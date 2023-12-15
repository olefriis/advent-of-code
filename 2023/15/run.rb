require 'pry'
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

boxes = []
256.times { boxes << [] }

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

groups.each { |group| perform(group, boxes) }
part2 = 0
boxes.each_with_index do |box, index|
  if box.length > 0
    box.each_with_index do |contents, index2|
      focal_length = contents[1]
      contribution = (index+1) * focal_length * (index2+1)
      part2 += contribution
    end
  end
end

puts "Part 2: #{part2}"
