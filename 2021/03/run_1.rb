lines = File.readlines('input')

zeroes = []
ones = []

lines.each do |line|
  line.chomp.chars.each_with_index do |char, idx|
    zeroes[idx] ||= 0
    ones[idx] ||= 0
    if char == '0'
      zeroes[idx] += 1
    elsif char == '1'
      ones[idx] += 1
    end
  end
end

gamma = ''
epsilon = ''
zeroes.each_with_index do |zero, idx|
  if zeroes[idx] > ones[idx]
    puts "gamma"
    gamma += '0'
    epsilon += '1'
  else
    puts 'epsilon'
    gamma += '1'
    epsilon += '0'
  end
end

converted_gamma = gamma.to_i(2)
converted_epsilon = epsilon.to_i(2)
puts "Answer: #{converted_gamma * converted_epsilon}"
