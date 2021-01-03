require 'set'
lines = File.readlines('input').map(&:strip)

splitter = lines.index('')
player1_cards, player2_cards = lines[1..splitter-1].map(&:to_i), lines[splitter+2..-1].map(&:to_i)


winner = nil

def play(player1_cards, player2_cards, game = 1)
  previous_configurations = Set.new
  round = 1
  until player1_cards.empty? || player2_cards.empty?
    #puts "-- Round #{round} (Game #{game})"
    round += 1
    configuration = player1_cards.map(&:to_s).join(',') + ':' + player2_cards.map(&:to_s).join(',')
    #p configuration
    if previous_configurations.include? configuration
      #puts "Found a previous configuration: #{configuration}"
      return [1, player1_cards]
    end
    previous_configurations << configuration

    p1_card = player1_cards.delete_at(0)
    p2_card = player2_cards.delete_at(0)

    #puts "Player 1 plays: #{p1_card}"
    #puts "Player 2 plays: #{p2_card}"

    if player1_cards.count >= p1_card && player2_cards.count >= p2_card
      #puts 'Recursing...'
      recursive_p1_cards = player1_cards[0...p1_card]
      recursive_p2_cards = player2_cards[0...p2_card]
      (winner, winner_cards) = play(recursive_p1_cards, recursive_p2_cards, game+1)
      #puts "Winner of recursion: #{winner}"
    else
      winner = (p1_card > p2_card) ? 1 : 2
    end

    #puts "Winner of round: #{winner}"

    winner_cards = [p1_card, p2_card].sort
    if winner == 1
      player1_cards << p1_card
      player1_cards << p2_card
    else
      player2_cards << p2_card
      player2_cards << p1_card
    end
  end

  if player1_cards.empty?
    [2, player2_cards]
  else
    [1, player1_cards]
  end
end

(winner, winner_cards) = play(player1_cards.clone, player2_cards.clone)

puts "Winner: #{winner}"
p winner_cards

score = winner_cards.each_with_index.map {|card, index| (winner_cards.length - index) * card}.sum
puts score
