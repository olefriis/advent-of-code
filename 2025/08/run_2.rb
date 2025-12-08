lines = File.readlines('08/input').map(&:strip)

# X, Y, Z
junction_boxes = lines.map {|line| line.split(',').map(&:to_i)}
# Junction box -> circuit number
circuits = {}
next_circuit_number = 1

def distance_squared(box1, box2)
  (box1[0] - box2[0])**2 + (box1[1] - box2[1])**2 + (box1[2] - box2[2])**2
end

possible_direct_connections_with_distance = junction_boxes.each_with_index.flat_map do |box1, i|
  junction_boxes[i+1..].map do |box2|
    dist = distance_squared(box1, box2)
    [dist, box1, box2]
  end.compact
end.sort_by {|dist, _, _| dist}

number_of_connections = 0
unused_junction_boxes = junction_boxes.to_set
possible_direct_connections_with_distance.each do |dist, box1, box2|
  unused_junction_boxes.delete(box1)
  unused_junction_boxes.delete(box2)

  #puts "Distance #{dist} between boxes at (#{box1[0]}, #{box1[1]}, #{box1[2]}) and (#{box2[0]}, #{box2[1]}, #{box2[2]})"
  if !circuits.key?(box1) && !circuits.key?(box2)
    #puts " None have any circuits, assigning new circuit number #{next_circuit_number}"
    circuits[box1] = circuits[box2] = next_circuit_number
    next_circuit_number += 1
    number_of_connections += 1
  elsif circuits.key?(box1) && !circuits.key?(box2)
    #puts " Box1 has circuit #{circuits[box1]}, assigning to box2"
    circuits[box2] = circuits[box1]
    number_of_connections += 1
  elsif !circuits.key?(box1) && circuits.key?(box2)
    #puts " Box2 has circuit #{circuits[box2]}, assigning to box1"
    circuits[box1] = circuits[box2]
    number_of_connections += 1
  elsif circuits[box1] != circuits[box2]
    #puts " Different circuits (#{circuits[box1]} and #{circuits[box2]}, merging)"
    old_circuit = circuits[box2]
    new_circuit = circuits[box1]
    circuits.keys.each do |box|
      if circuits[box] == old_circuit
        circuits[box] = new_circuit
      end
    end
    number_of_connections += 1
  else
    #puts " Same circuit (#{circuits[box1]}), doing nothing"
    # They are already part of the same circuit - do nothing
    number_of_connections += 1
  end

  if unused_junction_boxes.empty? && circuits.values.uniq.count == 1
    puts "Part 2: #{box1[0] * box2[0]}"
    exit
  end
  #break if number_of_connections >= 1000
end
