require 'pry'
#cups = '389125467'.chars.map(&:to_i)
cups = '389547612'.chars.map(&:to_i)

Node = Struct.new(:number, :next_node)

next_number = cups.max + 1
(1000000 - cups.length).times do
  cups << next_number
  next_number += 1
end

MAX_CUP = cups.max

INDEX_TO_CUPS = []
last_node = nil
first_node = nil
cups.each do |cup|
  node = Node.new(cup, nil)
  INDEX_TO_CUPS[cup] = node
  first_node = node unless first_node
  last_node.next_node = node if last_node
  last_node = node
end
last_node.next_node = first_node

def remove_3(current_cup)
  result = []
  next_node = current_cup.next_node
  3.times do
    result << current_cup.next_node
    current_cup.next_node = current_cup.next_node.next_node
  end
  result
end

def destination_cup(current_cup, removed_cups)
  removed_values = removed_cups.map(&:number)
  attempted_value = current_cup.number - 1
  loop do
    #puts "Attempting #{attempted_value}"
    attempted_value = MAX_CUP if attempted_value == 0
    return INDEX_TO_CUPS[attempted_value] unless removed_cups.map(&:number).include? attempted_value
    attempted_value -= 1
  end
end

def insert_cups(destination_cup, to_be_inserted)
  to_be_inserted.last.next_node = destination_cup.next_node
  destination_cup.next_node = to_be_inserted.first
end

def print_cups(current_cup)
  result = ''
  MAX_CUP.times do
    result += current_cup.number.to_s
    result += ','
    current_cup = current_cup.next_node
  end
  result
end

current_cup = first_node
10000000.times do |iteration|
  puts "Iteration #{iteration}" if iteration % 100000 == 0
  #p print_cups(current_cup)
  three_cups = remove_3(current_cup)
  #puts "Picks up #{three_cups.map(&:number)}"
  destination = destination_cup(current_cup, three_cups)
  #puts "Destination: #{destination.number}"
  new_current_cup = current_cup.next_node
  insert_cups(destination, three_cups)
  current_cup = new_current_cup
  #puts "New current cup: #{current_cup.number}"
end

cup_1 = INDEX_TO_CUPS[1]
number_1 = cup_1.next_node.number
number_2 = cup_1.next_node.next_node.number

puts "Number 1: #{number_1}"
puts "Number 2: #{number_2}"
puts "Multiplied: #{number_1 * number_2}"
#p cups

#cup_1 = cups.index(1)
#result = cups[cup_1+1...-1] + cups[0...cup_1-1]
#$puts result.join