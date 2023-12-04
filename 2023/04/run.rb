LINES = File.readlines('04/input').map(&:strip)

part1 = 0
LINES.each do |line|
  line =~ /Card\s+(\d+): (.*) \| (.*)/
  card, first_part, last_part = $1, $2, $3
  first_numbers = first_part.scan(/\d+/)
  last_numbers = last_part.scan(/\d+/)

  common = first_numbers & last_numbers
  part1 += 2.pow(common.count - 1) if common.count > 0
end
puts "Part 1: #{part1}"

extra_card_counters = [[1, LINES.count + 1]]
part2 = 0
LINES.each do |line|
  line =~ /Card\s+(\d+): (.*) \| (.*)/
  card, first_part, last_part = $1, $2, $3
  first_numbers = first_part.scan(/\d+/)
  last_numbers = last_part.scan(/\d+/)

  common_count = (first_numbers & last_numbers).count
  cards_this_round = extra_card_counters.sum { |multiples, _counter| multiples }
  part2 += cards_this_round

  extra_card_counters = extra_card_counters.select { |multiples, cards| cards > 1 }.map { |multiples, cards| [multiples, cards - 1] }
  extra_card_counters << [cards_this_round, common_count] if common_count > 0
end
puts "Part 2: #{part2}"
