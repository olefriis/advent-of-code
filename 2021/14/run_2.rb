lines = File.readlines('input').map(&:strip)

template = lines[0]
rules = lines[2..-1].map { |line| line.split(' -> ') }.to_h

pairs = (0...(template.length - 1)).map { |i| template[i..(i + 1)] }.tally
40.times do
  new_pairs = Hash.new { |h, k| h[k] = 0 }
  pairs.each do |pair, count|
    to_insert = rules[pair]
    if to_insert
      new_pairs["#{pair[0]}#{to_insert}"] += count
      new_pairs["#{to_insert}#{pair[1]}"] += count
    else
      new_pairs[pair] += count
    end
  end
  pairs = new_pairs
end

char_counts = Hash.new { |h, k| h[k] = 0 }
pairs.each { |pair, count| char_counts[pair[0]] += count }
char_counts[template[-1]] += 1

min_char_count, max_char_count = char_counts.values.minmax
puts (max_char_count - min_char_count)
