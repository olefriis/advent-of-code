lines = File.readlines('12/input').map(&:strip)

def solve(conditions, groups, result_cache = {})
  if answer = result_cache["#{conditions.length}-#{groups.length}"]
    return answer
  end

  required_remaining_conditions = (groups.size-1) + groups.sum
  return 0 if conditions.length < required_remaining_conditions
  return 1 if groups.empty? && conditions.all? {|c| c == '.' || c == '?'}

  if conditions[0] == '?'
    # Try out both possibilities
    conditions[0] = '#'
    p1 = solve(conditions, groups, result_cache)
    conditions[0] = '.'
    p2 = solve(conditions, groups, result_cache)
    # ...and put back the ? so we don't mess up other calculations
    conditions[0] = '?'
    result_cache["#{conditions.length}-#{groups.length}"] = p1 + p2
    return p1 + p2
  elsif conditions[0] == '.'
    solve(conditions[1..-1], groups, result_cache) 
  elsif conditions[0] == '#'
    return 0 if groups.empty? # We need a group, but don't have one

    # Gotta use the next group
    group = groups[0]
    return 0 unless conditions[0...group].all? {|c| c == '?' || c == '#'}
  
    # If the group is followed by a #, the group is too small, hence we have no match
    return 0 if conditions.length >= group && conditions[group] == '#'
  
    remaining_conditions = group >= conditions.length ? [] : conditions[(group+1)..-1]
    solve(remaining_conditions, groups[1..-1], result_cache)
  else
    raise "Unexpected condition: #{conditions} - #{groups}"
  end
end

input = lines.map do |line|
  conditions, groups = line.split(' ')
  [conditions.chars, groups.split(',').map(&:to_i)]
end
ps = input.map { |i| solve(*i) }
puts "Part 1: #{ps.sum}"

input2 = input.map do |i|
  conditions = i[0] + ['?'] + i[0] + ['?'] + i[0] + ['?'] + i[0] + ['?'] + i[0]
  groups = i[1]*5
  [conditions, groups]
end
ps2 = input2.map { |i| solve(*i) }
puts "Part 2: #{ps2.sum}"
