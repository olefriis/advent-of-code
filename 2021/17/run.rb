File.read('input').strip =~ /^target area: x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)$/
x1, x2, y1, y2 = $1.to_i, $2.to_i, $3.to_i, $4.to_i

def valid_trajectory_x?(trajectory_x, x1, x2)
  x = 0
  while x <= x2
    return true if x >= x1 && x <= x2
    x += trajectory_x
    trajectory_x -= 1
    return false if trajectory_x == 0
  end
  false
end

def valid_trajectory_y?(trajectory_y, y1, y2)
  y = 0
  while y >= y1
    return true if y >= y1 && y <= y2
    y += trajectory_y
    trajectory_y -= 1
  end
  false
end
  

def valid_trajectory?(trajectory_x, trajectory_y, x1, x2, y1, y2)
  x, y = 0, 0
  highest_y = 0
  while y >= y1
    return [true, highest_y] if x >= x1 && x <= x2 && y >= y1 && y <= y2
    highest_y = [y, highest_y].max
    x += trajectory_x
    y += trajectory_y
    trajectory_x -= 1 if trajectory_x > 0
    trajectory_y -= 1
  end
  [false, nil]
end

possible_trajectories_x = (1..x2).filter { |trajectory_x| valid_trajectory_x?(trajectory_x, x1, x2) }
possible_trajectories_y = (y1..(-y1)).filter { |trajectory_y| valid_trajectory_y?(trajectory_y, y1, y2) }

max_height, number_of_hits = 0, 0
possible_trajectories_x.each do |trajectory_x|
  possible_trajectories_y.each do |trajectory_y|
    is_valid, max_height_for_trajectory = valid_trajectory?(trajectory_x, trajectory_y, x1, x2, y1, y2)
    if is_valid
      number_of_hits += 1
      max_height = [max_height_for_trajectory, max_height].max
    end
  end
end

puts "Part 1: #{max_height}"
puts "Part 2: #{number_of_hits}"
