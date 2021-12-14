lines = File.readlines('input').map(&:strip)

template = lines[0]
RULES = {}
lines[2..-1].each do |line|
  first, second = line.split(' -> ')
  RULES[first] = second
end

pairs = {}
for i in 0...(template.length - 1)
  pair = template[i..(i + 1)]
  pairs[pair] = 1 + (pairs[pair] || 0)
end

40.times do |round|
  new_pairs = {}
  pairs.keys.each do |pair|
    to_insert = RULES[pair]
    if to_insert
      pair_1 = "#{pair[0]}#{to_insert}"
      pair_2 = "#{to_insert}#{pair[1]}"
      new_pairs[pair_1] = pairs[pair] + (new_pairs[pair_1] || 0)
      new_pairs[pair_2] = pairs[pair] + (new_pairs[pair_2] || 0)
    else
      new_pairs[pair] = pairs[pair] + (new_pairs[pair] || 0)
    end
  end
  pairs = new_pairs
end

char_counts = {}
pairs.keys.each do |pair|
  char_1 = pair[0]
  char_counts[char_1] = (char_counts[char_1] || 0) + pairs[pair]
end
char_counts[template[-1]] += 1

min_char = char_counts.keys.min_by { |c| char_counts[c] }
max_char = char_counts.keys.max_by { |c| char_counts[c] }

number_of_min_chars = char_counts[min_char]
number_of_max_chars = char_counts[max_char]

puts (number_of_max_chars - number_of_min_chars)
