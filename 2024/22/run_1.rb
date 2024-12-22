input = File.readlines('22/input').map(&:strip)

a = 123

def next_number(a)
    b = a * 64
    a = (a ^ b) % 16777216

    b = a / 32
    a = (a ^ b) % 16777216

    b = a * 2048
    a = (a ^ b) % 16777216

    a
end

part_1 = 0
input.each do |line|
    a = line.to_i
    2000.times { a = next_number(a) }
    part_1 += a
end

puts "Part 1: #{part_1}"
