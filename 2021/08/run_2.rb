def determine_mapping(line)
  encoded_digits = line.split(' ').map {|connections| connections.split('').sort}

  # The easy ones first
  # 1:   c  f 
  one = encoded_digits.find { |connections| connections.length == 2 }
  # 7: a c  f 
  seven = encoded_digits.find { |connections| connections.length == 3 }
  # 4:  bcd f 
  four = encoded_digits.find { |connections| connections.length == 4 }
  # 8: abcdefg
  eight = encoded_digits.find { |connections| connections.length == 7 }

  # We can find 2:
  # 2: a cde g - two connections in common with 4
  # 3: a cd fg - three connections in common with 4
  # 5: ab d fg - three connections in common with 4
  five_connection_digits = encoded_digits.select { |connections| connections.length == 5 }
  two = five_connection_digits.find { |digit| (four & digit).length == 2 }
  five_connection_digits.delete(two)
  # Remaining with 5 connections:
  # 3: a cd fg - two connections in common with 1
  # 5: ab d fg - one connection in common with 1
  three = five_connection_digits.find { |digit| (one & digit).length == 2 }
  five = five_connection_digits.find { |digit| (one & digit).length == 1 }

  six_connection_digits = encoded_digits.filter { |connections| connections.length == 6 }
  # 0: abc efg
  # 6: ab defg
  # 9: abcd fg
    
  # 6 has only one connection in common with 1
  six = six_connection_digits.find { |digit| (one & digit).length == 1 }
  six_connection_digits.delete(six)

  # Remaining with 6 connections:
  # 0: abc efg
  # 9: abcd fg

  # 4 and 9 have bcdf in common
  nine = six_connection_digits.find { |digit| (four & digit).length == 4 }
  zero = six_connection_digits.find { |digit| (four & digit).length != 4 }

  {
    zero.join('') => '0',
    one.join('') => '1',
    two.join('') => '2',
    three.join('') => '3',
    four.join('') => '4',
    five.join('') => '5',
    six.join('') => '6',
    seven.join('') => '7',
    eight.join('') => '8',
    nine.join('') => '9'
  }
end

lines = File.readlines('input').map(&:strip)

result = lines.map do |line|
  first, second = line.split(' | ')
  mapping = determine_mapping(first)
  decoded_digits = second.split(' ').map {|digit| mapping[digit.split('').sort.join]}
  decoded_digits.join.to_i
end.sum

puts result