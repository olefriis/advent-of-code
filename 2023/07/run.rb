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

def compare_hands_1(hand1, hand2)
  type1 = type_of_hand_1(hand1)
  type2 = type_of_hand_1(hand2)
  if type1 != type2
    HANDS.index(type1) <=> HANDS.index(type2)
  else
    card_values_1 = hand1.chars.map { |card| CARDS_1.index(card) }
    card_values_2 = hand2.chars.map { |card| CARDS_1.index(card) }
    card_values_1 <=> card_values_2
  end
end

def compare_hands_2(hand1, hand2)
  type1 = type_of_hand_2(hand1)
  type2 = type_of_hand_2(hand2)
  if type1 != type2
    HANDS.index(type1) <=> HANDS.index(type2)
  else
    card_values_1 = hand1.chars.map { |card| CARDS_2.index(card) }
    card_values_2 = hand2.chars.map { |card| CARDS_2.index(card) }
    card_values_1 <=> card_values_2
  end
end

def type_of_hand_1(hand)
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

def type_of_hand_2(hand)
  same_labels = [0, 0, 0, 0, 0, 0]
  number_of_js = hand.chars.count('J')
  individual_cards = hand.chars.select { |card| card != 'J' }
  CARDS_2.each do |card|
    amount = individual_cards.count(card)
    same_labels[amount] += 1
  end
  if same_labels[5] > 0 || (same_labels[4] > 0 && number_of_js >= 1) || (same_labels[3] > 0 && number_of_js >= 2) || (same_labels[2] > 0 && number_of_js >= 3) || (same_labels[1] > 0 && number_of_js >= 4) || number_of_js >= 5
    :five_of_a_kind
  elsif same_labels[4] > 0 || (same_labels[3] > 0 && number_of_js >= 1) || (same_labels[2] > 0 && number_of_js >= 2) || (same_labels[1] > 0 && number_of_js >= 3) || number_of_js >= 4
    :four_of_a_kind
  elsif (same_labels[3] > 0 && same_labels[2] > 0) || (same_labels[2] == 2 && number_of_js >= 1) || (same_labels[3] == 1 && number_of_js >= 2) || (same_labels[2] == 1 && number_of_js >= 3)
    :full_house
  elsif same_labels[3] > 0 || (same_labels[2] > 0 && number_of_js >= 1) || number_of_js >= 2
    :three_of_a_kind
  elsif same_labels[2] > 1 || (same_labels[2] > 0 && number_of_js >= 2)
    :two_pairs
  elsif same_labels[2] > 1 || number_of_js >= 2
    :one_pair
  elsif same_labels[2] > 0 || number_of_js >= 1
    :one_pair
  else
    :high_card
  end
end

lines.each do |line|
  hand, bid = line.split(' ')
  hands << hand
  hands_to_bids[hand] = bid
end

ordered_hands_1 = hands.sort {|hand1, hand2| compare_hands_1(hand1, hand2)}
ordered_hands_2 = hands.sort {|hand1, hand2| compare_hands_2(hand1, hand2)}

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
