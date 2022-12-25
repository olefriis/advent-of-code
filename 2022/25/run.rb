def to_base_5_digits(decimal)
  digits, base, remainder = 0, 1, decimal
  while base < decimal
    digits += 1
    base *= 5
  end

  result = []
  digits.downto(0) do |i|
    digit = remainder / base
    result << digit
    remainder -= digit * base
    base /= 5
  end
  result
end

def base_5_to_snafu(digits)
  position = digits.length - 1

  while position >= 0
    if digits[position] >= 5
      digits[position-1] += digits[position] / 5
      digits[position] %= 5
    end

    if digits[position] == 3
      raise 'At position 0' if position == 0
      digits[position-1] += 1
      digits[position] = -2
    elsif digits[position] == 4
      raise 'At position 0' if position == 0
      digits[position-1] += 1
      digits[position] = -1
    elsif ![-2, -1, 0, 1, 2].include?(digits[position])
      raise "Position #{position} is #{digits[position]}"
    end
    position -= 1
  end
  # Remove leading 0s
  while digits[0] == 0
    digits.shift
  end

  digits.map {|digit| {-2 => '=', -1 => '-', 0 => '0', 1 => '1', 2 => '2'}[digit]}.join
end

def to_snafu(number)
  base_5_to_snafu(to_base_5_digits(number))
end

def from_snafu(snafu)
  result = 0
  snafu.chars.each do |char|
    result *= 5
    result += {'=' => -2, '-' => -1, '0' => 0, '1' => 1, '2' => 2}[char]
  end
  result
end

converted = File.readlines('25/input', chomp: true).map {|line| from_snafu(line)}
sum = converted.sum
puts "Part 1: #{to_snafu(sum)}"
