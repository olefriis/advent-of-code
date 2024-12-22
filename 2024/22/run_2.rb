input = File.readlines('22/input').map(&:strip)
require 'pry'
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

SECRETS = []
input.each do |line|
    a = line.to_i
    secrets = [a]
    2000.times { a = next_number(a); secrets << a }
    SECRETS << secrets
end

PRICES = SECRETS.map do |line|
    line.map { |secret| secret % 10 }
end

def two_digit_string_number(n)
    n >= 0 ? " #{n}" : "#{n}"
end

def two_digit_sequence(sequence)
    result = ''
    sequence.each do |n|
        result += two_digit_string_number(n)
    end
    result
end

DIFFS = PRICES.map do |line|
    line.each_cons(2).map { |a, b| b - a }
end

DIFF_STRINGS = DIFFS.map do |line|
    line.map {|n| two_digit_string_number(n) }.join
end

sequences_to_check = Set.new
DIFFS.each do |line|
    line.each_cons(4) do |c|
        sequences_to_check << two_digit_sequence(c)
    end
end

def check_sequence(sequence)
    result = 0
    DIFF_STRINGS.each_with_index do |diff_line, y|
        index = diff_line.index(sequence)
        if index
            x = index / 2
            result += PRICES[y][x+4]
        end
    end
    result
end

part_2 = 0
puts "A total of #{sequences_to_check.count} to count"
sequences_to_check.each_with_index do |change_sequence, i|
    puts i if i % 100 == 0
    part_2 = [check_sequence(change_sequence), part_2].max
end
puts "Part 2: #{part_2}"
