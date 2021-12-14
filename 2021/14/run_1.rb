lines = File.readlines('input').map(&:strip)

template = lines[0]
RULES = {}
lines[2..-1].each do |line|
  first, second = line.split(' -> ')
  RULES[first] = second
end

PAIRS = {}
for i in 0...(template.length - 1)
  PAIRS[template[i..(i + 1)]] = 1
end

10.times do |round|
  new_template = ''
  for i in 0...(template.length - 1)
    chunk = template[i..(i + 1)]
    new_template << template[i]
    new_template << RULES[chunk] if RULES.key?(chunk)
  end
  new_template << template[-1]
  template = new_template
end

chars = template.split('')
min_char = chars.uniq.min_by { |c| chars.count(c) }
max_char = chars.uniq.max_by { |c| chars.count(c) }

number_of_min_chars = chars.count(min_char)
number_of_max_chars = chars.count(max_char)

puts (number_of_max_chars - number_of_min_chars)
