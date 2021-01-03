require 'pry'

lines = File.readlines('input').map(&:strip)

MemNode = Struct.new(:zero, :one, )

memory = {}
mask = ''

def masked(mask, value)
  value_binary = value.to_i.to_s(2)
  value_binary = ('0' * (36 - value_binary.length)) + value_binary
  value_binary.chars.zip(mask.chars).map do |v, m|
    if m == '0'
      v
    elsif m == '1'
      '1'
    else
      'X'
    end
  end.join
end

def possible_values(masked)
  x_index = masked.index('X')
  return [masked.to_i(2)] unless x_index

  zeroes = masked.clone
  zeroes[x_index] = '0'
  ones = masked.clone
  ones[x_index] = '1'
  [*possible_values(zeroes), *possible_values(ones)]
end

lines.each do |line|
  if line =~ /^mask = ([10X]{36})$/
    mask = $1
  elsif line =~ /^mem\[(\d+)\] = (\d+)$/
    address, value = $1, $2.to_i
    masked_address = masked(mask, address)
    addresses = possible_values(masked_address)
    addresses.each {|address| memory[address] = value}
  else
    raise "Weird line: #{line}"
  end
end

puts memory.values.sum