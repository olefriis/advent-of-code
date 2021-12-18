def apply_left_explode(number, exploding)
  (number.length-1).downto(0) do |i|
    if number[i].is_a?(Integer)
      number[i] += exploding[0]
      exploding[0] = 0
    else
      apply_left_explode(number[i], exploding)
    end
  end
end

def apply_right_explode(number, exploding)
  0.upto(number.length-1) do |i|
    if number[i].is_a?(Integer)
      number[i] += exploding[1]
      exploding[1] = 0
    else
      apply_right_explode(number[i], exploding)
    end
  end
end

def explode(number, level)
  if level < 3
    return if number.is_a?(Integer)
    first_exploding_array_index = nil
    exploding_array = nil
    0.upto(number.length-1) do |i|
      exploding_array = explode(number[i], level+1)
      if exploding_array
        first_exploding_array_index = i
        break
      end
    end
    return unless first_exploding_array_index

    (first_exploding_array_index-1).downto(0) do |i|
      if number[i].is_a?(Integer)
        number[i] += exploding_array[0]
        exploding_array[0] = 0
      else
        apply_left_explode(number[i], exploding_array)
      end
    end

    if first_exploding_array_index < number.length-1
      (first_exploding_array_index+1).upto(number.length-1) do |i|
        if number[i].is_a?(Integer)
          number[i] += exploding_array[1]
          exploding_array[1] = 0
        else
          apply_right_explode(number[i], exploding_array)
        end
      end
    end

    exploding_array
  elsif level > 3
    raise 'Level too deep'
  else # level == 3
    return if number.is_a?(Integer)
    first_array_index = number.find_index { |n| n.is_a?(Array) }
    return unless first_array_index
    exploding_array = number[first_array_index]
    number[first_array_index] = 0
    if first_array_index > 0
      number[first_array_index-1] += exploding_array[0]
      exploding_array[0] = 0
    end
    (first_array_index+1).upto(number.length-1) do |i|
      if number[i].is_a?(Array)
        number[i][0] += exploding_array[1]
      else
        number[i] += exploding_array[1]
      end
      exploding_array[1] = 0
    end

    exploding_array
  end
end

def split(number)
  has_split = false
  0.upto(number.length-1) do |i|
    return true if has_split
    if number[i].is_a?(Array)
      has_split ||= split(number[i])
    else
      n = number[i]
      if number[i] >= 10
        half_rounded_down = n/2
        number[i] = [half_rounded_down, n - half_rounded_down]
        has_split = true
      end
    end
  end
  has_split
end

def magnitude(numbers)
  if numbers.is_a?(Integer)
    numbers
  else
    3*magnitude(numbers[0]) + 2*magnitude(numbers[1])
  end
end

def reduce(number)
  loop do
    next if explode(number, 0)
    next if split(number)

    break
  end
end

lines = File.readlines('input').map {|line| eval line}
sum = lines[0]
1.upto(lines.length - 1) do |i|
  line = lines[i]
  reduce(sum)
  reduce(line)
  puts ''
  puts "  #{sum}"
  puts "+ #{line}"
  sum = [sum, line]
  reduce(sum)
  puts "= #{sum}"
end

puts magnitude(sum)
