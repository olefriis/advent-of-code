input = File.readlines('22/input').map(&:strip)

def next_secret(a)
    b = a * 64
    a = (a ^ b) % 16777216

    b = a / 32
    a = (a ^ b) % 16777216

    b = a * 2048
    a = (a ^ b) % 16777216

    a
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

best_sequence = sequence_values.max_by(&:last)
puts "Part 2: #{best_sequence.last}"
