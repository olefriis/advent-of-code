lines = File.readlines('input').map(&:strip)

memory = {}
mask = ''

def masked(mask, value)
  value_binary = value.to_i.to_s(2)
  value_binary = ('0' * (36 - value_binary.length)) + value_binary
  #puts "Value binary: #{value_binary}"
  #puts "Mask:         #{mask}"
  result = value_binary.chars.zip(mask.chars).map {|v, m| if m == 'X' then v else m end }.join
  #puts "Result:       #{result}"
  result.to_i(2)
end

lines.each do |line|
  if line =~ /^mask = ([10X]{36})$/
    mask = $1
  elsif line =~ /^mem\[(\d+)\] = (\d+)$/
    address, value = $1, $2
    memory[address] = masked(mask, value)
  else
    raise "Weird line: #{line}"
  end
end

p memory

puts memory.values.sum