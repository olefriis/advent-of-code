lines = File.readlines('04/input').map(&:strip)

part1 = 0
part2 = 0

extra_card_counters = [[1, lines.count + 1]]
lines.each do |line|
  winning_numbers = line.split(':').last.split('|').map {|s| s.scan(/\d+/) }.inject(&:&).count
  part1 += 2.pow(winning_numbers - 1) if winning_numbers > 0

  cards_this_round = extra_card_counters.sum(&:first)
  part2 += cards_this_round

  extra_card_counters = extra_card_counters.select { |_, cards| cards > 1 }.map { |multiples, cards| [multiples, cards - 1] }
  extra_card_counters << [cards_this_round, winning_numbers] if winning_numbers > 0
end

puts "Part 1: #{part1}"
puts "Part 2: #{part2}"
