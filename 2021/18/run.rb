def magnitude(numbers)
  if numbers.is_a?(Integer)
    numbers
  else
    3*magnitude(numbers[0]) + 2*magnitude(numbers[1])
  end
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
      number1, number2 = token, number[i+2] # Skip the ','
      4.times { number.delete_at(i) } # Delete '[number1,number2]' except one token
      number[i-1] = 0
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
      number.insert(i+1, half_rounded_down)
      number.insert(i+2, ',')
      number.insert(i+3, token - half_rounded_down)
      number.insert(i+4, ']')
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

lines = File.readlines('input').map(&:strip)

sum = parse(lines[0])
1.upto(lines.length - 1) do |i|
  line = parse(lines[i])
  reduce(sum)
  reduce(line)
  puts ''
  puts "  #{sum.join}"
  puts "+ #{line.join}"
  sum = ['[', *sum, ',', *line, ']']
  reduce(sum)
  puts "= #{sum.join}"
end
puts "Magnitude of sum: #{magnitude(eval(sum.join))}"

max_magnitude = 0
lines.each do |line1|
  lines.each do |line2|
    sum = ['[', *parse(line1), ',', *parse(line2), ']']
    reduce(sum)
    max_magnitude = [max_magnitude, magnitude(eval(sum.join))].max
  end
end
puts "Max magnitude: #{max_magnitude}"
