require 'pry'
# 1: cf - so cf are ambiguous
# 7: acf - so can find a

# Can now find 6 - only number without acf

# 9: abcd fg - so can find e
# ae

# Find the two with 5 digits. The one missing e is 5, the other is 2. And then we can find b
# abe - 25

# Find those with 6 digits.
# * The one missing b is 3.
# * The one missing e is 9.
# * The one missing c or f is 6.
# * The last one is 0.

def determine_mapping(line)
  mapping = {}
  encoded_digits = line.split(' ').map {|connections| connections.split('').sort}

  # The easy ones first
  # 1:   c  f  (2*)
  one = encoded_digits.find { |connections| connections.length == 2 }
  # 7: a c  f  (3*)
  seven = encoded_digits.find { |connections| connections.length == 3 }
  # 4:  bcd f  (4*)
  four = encoded_digits.find { |connections| connections.length == 4 }
  # 8: abcdefg (7*)
  eight = encoded_digits.find { |connections| connections.length == 7 }

  # We can find 2:
  # 2: a cde g - two connections in common with 4
  # 3: a cd fg - three connections in common with 4
  # 5: ab d fg - three connections in common with 4
  five_connection_digits = encoded_digits.select { |connections| connections.length == 5 }
  two = five_connection_digits.find { |digit| (four & digit).length == 2 }
  five_connection_digits.delete(two)
  # Remaining:
  # 3: a cd fg - two connections in common with 1
  # 5: ab d fg - one connection in common with 1
  three = five_connection_digits.find { |digit| (one & digit).length == 2 }
  five = five_connection_digits.find { |digit| (one & digit).length == 1 }

  six_connection_digits = encoded_digits.filter { |connections| connections.length == 6 }
  # 0: abc efg (6)
  # 6: ab defg (6)
  # 9: abcd fg (6)
    
  # 6 has only one connection in common with 1
  six = six_connection_digits.find { |digit| (one & digit).length == 1 }
  six_connection_digits.delete(six)

  # Remaining with 6 connections:
  # 0: abc efg (6)
  # 3: a cd fg (6)
  # 9: abcd fg (6)

  # 4 and 9 have bcdf in common
  # 4:  bcd f  (4)
  nine = six_connection_digits.find { |digit| (four & digit).length == 4 }
  six_connection_digits.delete(nine)

  # Remaining with 6 connections:
  # 0: abc efg (6)
  # 3: a cd fg (6)

  # With 6:
  # 0: abc efg (6) - abefg in common with 6
  zero = six_connection_digits.find { |digit| (six & digit).length == 5 }

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

# With 2:
# 1:   c  f  (2)

# With 3:
# 7: a c  f  (3)

# With 4:
# 4:  bcd f  (4)

# With 5:
# 2: a cde g (5) **
# 5: ab d fg (5) ***

# With 6:
# 0: abc efg (6) - abcfg in common with 9, abefg in common with 6
# 3: a cd fg (6) - acdfg in common with 9, adfg in common with 6

# 9: abcd fg (6)
# 6: ab defg (6)

# With 7:
# 8: abcdefg (7)




# 0: abc efg (6)
# 1:   c  f  (2*)
# 2: a cde g (5)
# 3: a cd fg (6)
# 4:  bcd f  (4*)
# 5: ab d fg (5)
# 6: ab defg (6)
# 7: a c  f  (3*)
# 8: abcdefg (7*)
# 9: abcd fg (6)


lines = File.readlines('input').map(&:strip)

sum = 0
lines.each do |line|
  first, second = line.split(' | ')
  mapping = determine_mapping(first)
  decoded_digits = second.split(' ').map {|digit| mapping[digit.split('').sort.join]}
  puts "Decoded: #{decoded_digits}"
  sum += decoded_digits.join('').to_i
end

puts sum
