# Test input
p1 = 4
p2 = 8

# Puzzle input
p1 = 10
p2 = 9

turn = 1

die = 1

p1 -= 1
p2 -= 1
p1_score = 0
p2_score = 0

while p1_score < 1000 && p2_score < 1000
  score = 0
  3.times do
    score += die
    die += 1
  end

  if turn == 1
    p1 += score
    p1 = p1 % 10
    p1_score += p1+1
    turn = 2
  else
    p2 += score
    p2 = p2 % 10
    p2_score += p2+1
    turn = 1
  end
end

p1 += 1
p2 += 1

puts "p1: #{p1}, p2: #{p2}, die: #{die}"
puts "p1_score: #{p1_score}, p2_score: #{p2_score}, die: #{die-1}"
