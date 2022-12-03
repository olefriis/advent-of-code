lines = File.readlines('02/input').map(&:strip)
values = {
  'A' => 0,
  'B' => 1,
  'C' => 2,
  'X' => 0,
  'Y' => 1,
  'Z' => 2,
}

def winning_score(opponent, you)
  return 3 if opponent == you
  return 6 if you == (opponent + 1) % 3
  return 0
end

rounds = lines.map { |line| line.split(' ') }.map do |round|
  round.map { |move| values[move] }
end

points_1 = rounds.map do |round|
  opponent, you = round
  you + 1 + winning_score(opponent, you)
end.sum

puts "Part 1: #{points_1}"

def appropriate_move(opponent, result)
  if result == 0
    # We need to loose, so we need to take the previous move
    (opponent + 2) % 3
  elsif result == 1
    # A draw, so we'll take the same as the opponent
    opponent
  else
    (opponent + 1) % 3
  end
end

points_2 = rounds.map do |round|
  opponent, result = round
  you = appropriate_move(opponent, result)
  you + 1 + winning_score(opponent, you)
end.sum

puts "Part 2: #{points_2}"
 