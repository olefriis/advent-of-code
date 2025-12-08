lines = File.readlines('08/input').map(&:strip)
junction_boxes = lines.map {|line| line.split(',').map(&:to_i)}

closest_boxes = junction_boxes.each_with_index.flat_map do |box1, i|
  junction_boxes[i+1..].map {|box2| [box1, box2]}
end.sort_by {|box1, box2| (box1[0] - box2[0])**2 + (box1[1] - box2[1])**2 + (box1[2] - box2[2])**2}

$circuits, $next_circuit_number, unused_junction_boxes = {}, 1, junction_boxes.to_set

def connect(box1, box2)
  if !$circuits.key?(box1) && !$circuits.key?(box2)
    $circuits[box1] = $circuits[box2] = $next_circuit_number
    $next_circuit_number += 1
  elsif $circuits.key?(box1) && !$circuits.key?(box2)
    $circuits[box2] = $circuits[box1]
  elsif !$circuits.key?(box1) && $circuits.key?(box2)
    $circuits[box1] = $circuits[box2]
  elsif $circuits[box1] != $circuits[box2]
    circuit1, circuit2 = $circuits[box2], $circuits[box1]
    $circuits.keys.each do |box|
      if $circuits[box] == circuit1
        $circuits[box] = circuit2
      end
    end
  end
end

part_1, part_2 = nil, nil
closest_boxes.each_with_index do |(box1, box2), index|
  connect(box1, box2)

  if index == 999
    circuit_sizes = $circuits.values.tally.values.sort.reverse
    part_1 = circuit_sizes[0..2].reduce(:*)
  end

  unused_junction_boxes.delete(box1)
  unused_junction_boxes.delete(box2)
  if unused_junction_boxes.empty? && $circuits.values.uniq.count == 1
    part_2 = box1[0] * box2[0]
  end

  break if part_1 && part_2
end

puts "Part 1: #{part_1}"
puts "Part 2: #{part_2}"
