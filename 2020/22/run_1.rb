lines = File.readlines('input').map(&:strip)

splitter = lines.index('')
player1_cards, player2_cards = lines[1..splitter-1].map(&:to_i), lines[splitter+2..-1].map(&:to_i)

p player1_cards
p player2_cards

until player1_cards.empty? || player2_cards.empty?
  p1_card = player1_cards.delete_at(0)
  p2_card = player2_cards.delete_at(0)

  if p1_card > p2_card
    player1_cards << p1_card
    player1_cards << p2_card
  else
    player2_cards << p2_card
    player2_cards << p1_card
  end
end


p player1_cards
p player2_cards

winner_cards = player1_cards.empty? ? player2_cards : player1_cards

p winner_cards

score = winner_cards.each_with_index.map {|card, index| (winner_cards.length - index) * card}.sum
puts score
