require 'pry'

lines = File.readlines('02/input').map(&:strip)
values = {
  'A' => 1,
  'B' => 2,
  'C' => 3,
  'X' => 1,
  'Y' => 2,
  'Z' => 3,
}

def winning_score(opponent, you)
  return 3 if opponent == you
  return 6 if you - 1 == opponent % 3
  return 0
end

rounds = lines.map { |line| line.split(' ') }.map do |round|
  round.map { |move| values[move] }
end

points_1 = rounds.map do |round|
  opponent, you = round
  you + winning_score(opponent, you)
end.sum

puts "Part 1: #{points_1}"

rounds_2 = rounds.map do |round|
  opponent, result = round
  you = if result == 1
    # We need to loose, so we need to take the previous move
    (opponent + 1) % 3 + 1
  elsif result == 2
    # A draw, so we'll take the same as the opponent
    opponent
  else
    (opponent % 3)  + 1
  end
  [opponent, you]
end

points_2 = rounds_2.map do |round|
  opponent, you = round
  you + winning_score(opponent, you)
end.sum

puts "Part 2: #{points_2}"
