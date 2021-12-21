lines = File.readlines('input').map(&:strip)
p1_position = lines[0].split(': ').last.to_i
p2_position = lines[1].split(': ').last.to_i

p1_turn = true
die = 1
p1_score, p2_score = 0, 0

# Subtract one, making it easier to use % below
p1_position -= 1
p2_position -= 1

while p1_score < 1000 && p2_score < 1000
  score = 0
  3.times do
    score += die
    die += 1
  end

  if p1_turn
    p1_position = (p1_position + score) % 10
    p1_score += p1_position + 1
  else
    p2_position = (p2_position + score) % 10
    p2_score += p2_position + 1
  end

  p1_turn = !p1_turn
end

puts "Result: #{[p1_score, p2_score].min * (die-1)}"
