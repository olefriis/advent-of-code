lines = File.readlines('08/input').map(&:strip)
junction_boxes = lines.map {|line| line.split(',').map(&:to_i)}
circuits, next_circuit_number, unused_junction_boxes = {}, 1, junction_boxes.to_set

part_1, part_2 = nil, nil
junction_boxes
  .combination(2)
  .sort_by {|box1, box2| (box1[0] - box2[0])**2 + (box1[1] - box2[1])**2 + (box1[2] - box2[2])**2}
  .each_with_index do |(box1, box2), index|

  if index == 1000
    circuit_sizes = circuits.values.tally.values.sort.reverse
    part_1 = circuit_sizes[0..2].reduce(:*)
  end

  if !circuits.key?(box1) && !circuits.key?(box2)
    circuits[box1] = circuits[box2] = next_circuit_number
    next_circuit_number += 1
  elsif circuits.key?(box1) && !circuits.key?(box2)
    circuits[box2] = circuits[box1]
  elsif !circuits.key?(box1) && circuits.key?(box2)
    circuits[box1] = circuits[box2]
  elsif circuits[box1] != circuits[box2]
    circuit1, circuit2 = circuits[box2], circuits[box1]
    circuits.keys.each do |box|
      circuits[box] = circuit2 if circuits[box] == circuit1
    end
  end

  unused_junction_boxes.delete(box1)
  unused_junction_boxes.delete(box2)

  number_of_circuits = circuits.values.uniq.size
  if unused_junction_boxes.empty? && number_of_circuits == 1
    part_2 = box1[0] * box2[0]
  end

  break if part_1 && part_2
end

puts "Part 1: #{part_1}"
puts "Part 2: #{part_2}"
