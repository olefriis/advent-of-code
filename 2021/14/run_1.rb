lines = File.readlines('input').map(&:strip)

template = lines[0]
rules = lines[2..-1].map { |line| line.split(' -> ') }.to_h

10.times do |round|
  new_template = ''
  for i in 0...(template.length - 1)
    chunk = template[i..(i + 1)]
    new_template << template[i]
    new_template << rules[chunk] if rules.key?(chunk)
  end
  new_template << template[-1]
  template = new_template
end

min_char_count, max_char_count = template.split('').tally.values.minmax
puts (max_char_count - min_char_count)
