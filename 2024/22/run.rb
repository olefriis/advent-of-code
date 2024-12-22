input = File.readlines('22/input').map(&:strip)

def next_secret(a)
    a = (a ^ (a * 64)) % 16777216
    a = (a ^ (a / 32)) % 16777216
    (a ^ (a * 2048)) % 16777216
end

sequence_values = Hash.new(0)
part_1 = 0
input.each do |line|
    secret = line.to_i
    secrets = [secret] + 2000.times.map { secret = next_secret(secret) }
    part_1 += secrets.last

    prices = secrets.map { |secret| secret % 10 }
    diffs = prices.each_cons(2).map { |a, b| b - a }

    seen = Set.new
    0.upto(diffs.count - 4) do |x|
        sequence = diffs[x...x+4]
        next if seen.include?(sequence)
        sequence_values[sequence] += prices[x+4]
        seen << sequence
    end
end
puts "Part 1: #{part_1}"

part_2 = sequence_values.values.max
puts "Part 2: #{part_2}"
