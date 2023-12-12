lines = File.readlines('12/input').map(&:strip)

ACCUMULATOR = {}

def possibilities(conditions, groups)
  answer = ACCUMULATOR["#{conditions.length}-#{groups.length}"]
  return answer if answer

  required_remaining_conditions = (groups.size-1) + groups.sum
  if conditions.length < required_remaining_conditions
    # puts "Not enough conditions: #{conditions} - #{groups}"
    return 0
  end
  if groups.empty? && conditions.all? {|c| c == '.' || c == '?'}
    # puts 'Done'
    return 1
  end

  if conditions[0] == '?'
    # puts "Found ?: #{conditions} - #{groups}"
    conditions[0] = '#'
    p1 = possibilities(conditions, groups)
    conditions[0] = '.'
    p2 = possibilities(conditions, groups)
    conditions[0] = '?'
    ACCUMULATOR["#{conditions.length}-#{groups.length}"] = p1 + p2
    return p1 + p2
  end

  if conditions[0] == '.'
    # puts "Relaying"
    return possibilities(conditions[1..-1], groups)
  end

  if conditions[0] == '#'
    # puts "Entering group: #{conditions} - #{groups}"
    if groups.empty?
      # puts "Oh, but we're out of groups"
      return 0
    end
    # Gotta use the next group
    group = groups[0]
    if conditions[0...group].all? {|c| c == '?' || c == '#'}
      # puts "We should use at least #{group} conditions"
      if conditions[group] == '#'
        # puts "Not gonna work - we need a longer group"
        return 0
      end
      new_conditions = group+1 > conditions.length ? [] : conditions[(group+1)..-1]
      # puts "Length of conditions: #{conditions.length}. Group length: #{groups.length}"
      # puts "Continuing with #{new_conditions.inspect} - #{groups[1..-1]}. Conditions is #{conditions}"
      return possibilities(new_conditions, groups[1..-1])
    else
      # puts "Group is too small - we need #{groups[0]} conditions: #{conditions} - #{groups}"
      return 0
    end
  else
    # puts "Unknown condition: #{conditions} - #{groups}"
  end
  0
end

input = lines.map do |line|
  conditions, groups = line.split(' ')
  [conditions.chars, groups.split(',').map(&:to_i)]
end

ps = input.map do |input|
  ACCUMULATOR.clear
  possibilities(input[0], input[1])
end
puts "Part 1: #{ps.sum}"

input2 = input.map do |i|
  conditions = i[0] + ['?'] + i[0] + ['?'] + i[0] + ['?'] + i[0] + ['?'] + i[0]
  groups = i[1] + i[1] + i[1] + i[1] + i[1]
  [conditions, groups]
end
ps2 = input2.map do |i|
  ACCUMULATOR.clear
  possibilities(i[0], i[1])
end

first_ps = possibilities(input2[0][0], input2[0][1])

puts "Part 2: #{ps2.sum}"
