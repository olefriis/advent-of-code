require 'pry'
number = [[[[[9,8],1],2],3],4]
becomes = [[[[0,9],2],3],4]

def simple?(number)
  number.length == 2 && number[0].is_a?(Number) && number[1].is_a?(Number)
end

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
  #puts "Diving into level #{level} #{number}"
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
    #puts "At level 3: #{number}"
    return if number.is_a?(Integer)
    first_array_index = number.find_index { |n| n.is_a?(Array) }
    return unless first_array_index
    exploding_array = number[first_array_index]
    #puts "Found an array at position #{first_array_index}: #{exploding_array}"
    number[first_array_index] = 0
    if first_array_index > 0
      #puts "number[first_array_index-1]: #{number[first_array_index-1]}"
      #puts "exploding_array[0]: #{exploding_array[0]}"
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
    #puts "After exploding level 3: #{number}"
    #puts "Returning #{exploding_array}"

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
  #puts "Reducing #{number}"
  loop do
    exploded = explode(number, 0)
    keep_going = !!exploded
    if keep_going
      #puts "We did an explosion: #{exploded}. New number: #{number}"
      next
    end

    keep_going = split(number)
    if keep_going
      #puts "We did a split             . New number: #{number}"
      next
    end

    break
  end
end

#to_split = [[[[0,7],4],[15,[0,13]]],[1,1]]
#puts "#{to_split} becomes..."
#split(to_split)
#puts "#{to_split}"

#to_explode = [[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]
#puts "#{to_explode} becomes..."
#explode(to_explode, 0)
#puts "#{to_explode}"

#to_reduce = [[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]
#puts "#{to_reduce} becomes..."
#reduce(to_reduce)
#puts "#{to_reduce}"

#puts magnitude([[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]])

lines = File.readlines('input').map {|line| eval line}
sum = lines[0]
1.upto(lines.length - 1) do |i|
#1.upto(1) do |i|
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
