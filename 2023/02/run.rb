lines = File.readlines('02/input').map(&:strip)

max = {
  'red' => 12,
  'green' => 13,
  'blue' => 14
}

part_1 = 0
part_2 = 0

lines.each do |line|
  line =~ /^Game (\d+): (.*)$/
  game_id, rounds = $1.to_i, $2
  min_required = {
    'red' => 0,
    'green' => 0,
    'blue' => 0
  }
  rounds.split(/;|,/).map(&:strip).each do |round|
    round =~ /^(\d+) (.*)$/
    number, color = $1.to_i, $2
    min_required[color] = [number, min_required[color]].max
  end
  game_is_possible = max.keys.all? {|key| max[key] >= min_required[key]}
  part_1 += game_id if game_is_possible
  part_2 += min_required.values.reduce(&:*)
end
puts "Part 1: #{part_1}"
puts "Part 2: #{part_2}"
