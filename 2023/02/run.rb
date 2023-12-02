lines = File.readlines('02/input').map(&:strip)

max = {
  'red' => 12,
  'green' => 13,
  'blue' => 14
}

passing_lines = lines.map do |line|
  line =~ /^Game (\d+): (.*)$/
  game_id, rounds = $1.to_i, $2
  success = rounds.split(';').map(&:strip).all? do |round_1|
    round_1.split(',').map(&:strip).all? do |inner_round|
      inner_round =~ /(\d+) (.*)$/
      number, color = $1.to_i, $2
      max[color] >= number
    end
  end
  success ? game_id : nil
end
puts "Part 1: #{passing_lines.compact.sum}"

min_cubes = lines.map do |line|
  line =~ /^Game (\d+): (.*)$/
  game_id, rounds = $1.to_i, $2
  min = {
    'red' => 0,
    'green' => 0,
    'blue' => 0
  }
  rounds.split(';').map(&:strip).each do |round_1|
    round_1.split(',').map(&:strip).each do |inner_round|
      inner_round =~ /(\d+) (.*)$/
      number, color = $1.to_i, $2
      min[color] = number if min[color] < number
    end
  end
  min.values.reduce(&:*)
end

puts "Part 2: #{min_cubes.sum}"
