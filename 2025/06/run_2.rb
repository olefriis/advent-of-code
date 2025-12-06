lines = File.readlines('06/input').map(&:chomp)

def rotate_90_degrees_right(matrix)
  matrix.transpose.map(&:reverse)
end

def rotate_90_degrees_left(matrix)
  rotate_90_degrees_right(rotate_90_degrees_right(rotate_90_degrees_right(matrix)))
end

rotated_lines = rotate_90_degrees_left(lines.map(&:chars) )

last_chunk = []
result = 0

def calculate_result(chunk)
  operator = chunk[-1][-1]
  chunk[-1][-1] = ' '  # Remove operator from chunk

  numbers = chunk.map {|line| line.join.strip.to_i }
  result = numbers[0]
  p numbers
  numbers[1..-1].each do |num|
    case operator
    when '+'
      result += num
    when '*'
      result *= num
    else
      raise "Unknown operator: #{operator}"
    end
  end

  puts "Calculating result for chunk of size #{chunk.length}: #{result}"

  result
end

rotated_lines.each do |line|
  if line.all? {|char| char == ' '}
    result += calculate_result(last_chunk)
    last_chunk = []
  else
    last_chunk << line
  end
end
result += calculate_result(last_chunk) if last_chunk.any?

puts "Part 2: #{result}"
