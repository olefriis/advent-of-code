assignment_pairs = File.readlines('04/input').map(&:strip).map do |line|
  line.split(',').map { |assignment| assignment.split('-').map(&:to_i) }
end

def fully_contains?(pair1, pair2)
  pair1[0] <= pair2[0] && pair1[1] >= pair2[1]
end

def overlaps?(pair1, pair2)
  !(pair1[1] < pair2[0] || pair1[0] > pair2[1])
end

fully_contained_pairs = assignment_pairs.count { |pair1, pair2| fully_contains?(pair1, pair2) || fully_contains?(pair2, pair1) }
puts "Part 1: #{fully_contained_pairs}"

overlapping_pairs = assignment_pairs.count { |pair1, pair2| overlaps?(pair1, pair2) }
puts "Part 2: #{overlapping_pairs}"
