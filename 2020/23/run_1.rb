require 'pry'
#cups = '389125467'.chars.map(&:to_i)
cups = '389547612'.chars.map(&:to_i)

def remove_3(cups, current_cup)
  result = []
  3.times do
    current_index = cups.index(current_cup)
    result << cups.delete_at((current_index + 1) % cups.length)
  end
  result
end

def destination_cup(cups, current_cup, removed_cups)
  lower = cups.select {|cup| cup < current_cup}.max
  return lower if lower
  higest = cups.max
end

def insert_cups(cups, destination_cup, to_be_inserted)
  index = cups.index(destination_cup)
  cups.insert(index+1, *to_be_inserted)
end

current_cup = cups.first
100.times do
  p cups
  three_cups = remove_3(cups, current_cup)
  puts "Picks up #{three_cups}"
  destination = destination_cup(cups, current_cup, three_cups)
  puts "Destination: #{destination}"
  new_current_cup = cups[(cups.index(current_cup) + 1) % cups.length]
  insert_cups(cups, destination, three_cups)
  current_cup = new_current_cup
  puts "New current cup: #{current_cup}"
end
p cups

#cup_1 = cups.index(1)
#result = cups[cup_1+1...-1] + cups[0...cup_1-1]
#$puts result.join