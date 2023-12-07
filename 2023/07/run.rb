lines = File.readlines('07/input').map(&:strip)

hands = []
hands_to_bids = {}

HANDS = [
  :five_of_a_kind,
  :four_of_a_kind,
  :full_house,
  :three_of_a_kind,
  :two_pairs,
  :one_pair,
  :high_card
].reverse

CARDS_1 = ['A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2'].reverse
CARDS_2 = ['A', 'K', 'Q', 'T', '9', '8', '7', '6', '5', '4', '3', '2', 'J'].reverse

def compare_hands(hand1, hand2, ordering, jokers)
  type1 = type_of_hand(hand1, jokers)
  type2 = type_of_hand(hand2, jokers)
  if type1 != type2
    HANDS.index(type1) <=> HANDS.index(type2)
  else
    card_values_1 = hand1.chars.map { |card| ordering.index(card) }
    card_values_2 = hand2.chars.map { |card| ordering.index(card) }
    card_values_1 <=> card_values_2
  end
end

def type_of_hand(hand, jokers)
  hand = substitute_js(hand) if jokers

  same_labels = [0, 0, 0, 0, 0, 0]
  individual_cards = hand.chars
  CARDS_1.each do |card|
    amount = individual_cards.count(card)
    same_labels[amount] += 1
  end
  if same_labels[5] > 0
    :five_of_a_kind
  elsif same_labels[4] > 0
    :four_of_a_kind
  elsif same_labels[3] > 0 && same_labels[2] > 0
    :full_house
  elsif same_labels[3] > 0
    :three_of_a_kind
  elsif same_labels[2] > 1
    :two_pairs
  elsif same_labels[2] > 1
    :one_pair
  elsif same_labels[2] > 0
    :one_pair
  else
    :high_card
  end
end

def substitute_js(hand)
  number_of_js = hand.chars.count('J')
  return 'AAAAA' if number_of_js >= 4

  cards_without_j = hand.chars.select { |card| card != 'J' }
  tallies = cards_without_j.tally
  most_repeating_card = cards_without_j.max_by { |card| tallies[card] }
  hand.gsub('J', most_repeating_card)
end

lines.each do |line|
  hand, bid = line.split(' ')
  hands << hand
  hands_to_bids[hand] = bid
end

ordered_hands_1 = hands.sort {|hand1, hand2| compare_hands(hand1, hand2, CARDS_1, false)}
ordered_hands_2 = hands.sort {|hand1, hand2| compare_hands(hand1, hand2, CARDS_2, true)}

total_winnings = 0
ordered_hands_1.each_with_index do |hand, index|
  bid = hands_to_bids[hand]
  total_winnings += bid.to_i * (index + 1)
end
puts "Part 1: #{total_winnings}"

total_winnings = 0
ordered_hands_2.each_with_index do |hand, index|
  bid = hands_to_bids[hand]
  total_winnings += bid.to_i * (index + 1)
end
puts "Part 2: #{total_winnings}"
