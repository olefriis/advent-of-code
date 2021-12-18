def magnitude(number)
  keep_going = true
  while keep_going
    keep_going = false
    (0...number.length).each do |i|
      if number[i] == '[' && number[i+1].is_a?(Integer) && number[i+2] == ',' && number[i+3].is_a?(Integer) && number[i+4] == ']'
        new_number = 3*number[i+1] + 2*number[i+3]
        4.times { number.delete_at(i) }
        number[i] = new_number
        keep_going = true
      end
    end
  end
  number[0]
end

def explode(number)
  level = 0
  number.each_with_index do |token, i|
    if token == ','
      # Ignore
    elsif token == '['
      level += 1
    elsif token == ']'
      level -= 1
    elsif level == 5
      # Gotta explode
      number1, number2 = token, number[i+2]
      number[i-1] = 0 # Replace the '[' with 0
      4.times { number.delete_at(i) } # ...and delete 'number1,number2]'
      (i-2).downto(0) do |j|
        if number[j].is_a?(Integer)
          number[j] += number1
          break
        end
      end
      i.upto(number.length-1) do |j|
        if number[j].is_a?(Integer)
          number[j] += number2
          break
        end
      end

      return true
    end
  end
  false
end

def split(number)
  number.each_with_index do |token, i|
    if token.is_a?(Integer) && token > 9
      half_rounded_down = token/2
      number[i] = '['
      number.insert(i+1, half_rounded_down, ',', token - half_rounded_down, ']')
      return true
    end
  end
  false
end

def parse(line)
  line.split('').map { |n| n.match(/\d/) ? n.to_i : n }
end

def reduce(number)
  loop do
    next if explode(number)
    next if split(number)
    break
  end
end

lines = File.readlines('input').map(&:strip).map { |line| parse(line) }

sum = lines[0]
lines[1..-1].each do |line|
  puts ''
  puts "  #{sum.join}"
  puts "+ #{line.join}"
  sum = ['[', *sum, ',', *line, ']']
  reduce(sum)
  puts "= #{sum.join}"
end
puts "Magnitude of sum: #{magnitude(sum)}"

max_magnitude = 0
lines.each do |line1|
  lines.each do |line2|
    sum = ['[', *line1, ',', *line2, ']']
    reduce(sum)
    max_magnitude = [max_magnitude, magnitude(sum)].max
  end
end
puts "Max magnitude: #{max_magnitude}"
