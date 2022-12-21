require 'pry'

lines = File.readlines('21/input', chomp: true)
resolved_monkeys = {}
Monkey = Struct.new(:name, :operator, :value1, :value2)
unresolved_monkeys = []

lines.each do |line|
  raise 'Invalid line' unless line =~ /(.*): (.*)/
  name, expression = $1, $2
  if expression =~ /^\d+$/
    resolved_monkeys[name] = expression.to_i
  else
    value1, operator, value2 = expression.split(' ')
    unresolved_monkeys << Monkey.new(name, operator, value1, value2)
  end
end

def solve_forwards(unresolved_monkeys, resolved_monkeys)
  resolved_monkeys = resolved_monkeys.dup
  keep_looping = true

  while keep_looping
    keep_looping = false
    previously_unresolved_monkeys = unresolved_monkeys.count
    unresolved_monkeys = unresolved_monkeys.select do |monkey|
      value1 = resolved_monkeys[monkey.value1]
      value2 = resolved_monkeys[monkey.value2]
      next true unless value1 && value2

      result = eval("#{value1} #{monkey.operator} #{value2}")
      resolved_monkeys[monkey.name] = result
      keep_looping = true
      false
    end
  end
  [unresolved_monkeys, resolved_monkeys]
end
new_unresolved_monkeys, new_resolved_monkeys = solve_forwards(unresolved_monkeys, resolved_monkeys)
puts "Part 1: #{new_resolved_monkeys['root']}"


humn = unresolved_monkeys.find {|monkey| monkey.name == 'humn'}
root = unresolved_monkeys.find {|monkey| monkey.name == 'root'}
unresolved_monkeys = unresolved_monkeys.reject {|monkey| [humn, root].include?(monkey)}
resolved_monkeys = resolved_monkeys.reject {|monkey_name| ['humn', 'root'].include?(monkey_name)}

partly_unresolved_monkeys, partly_resolved_monkeys = solve_forwards(unresolved_monkeys, resolved_monkeys)

# Now solve backwards!
missing_variable = nil
value_of_missing_variable = nil
if partly_resolved_monkeys[root.value1]
  missing_variable = root.value2
  value_of_missing_variable = partly_resolved_monkeys[root.value1]
else
  missing_variable = root.value1
  value_of_missing_variable = partly_resolved_monkeys[root.value2]
end
partly_resolved_monkeys[missing_variable] = value_of_missing_variable

monkey_hash = {}
unresolved_monkeys.each do |monkey|
  monkey_hash[monkey.name] = monkey
end

loop do
  if missing_variable == 'humn'
    puts "Part 2: #{value_of_missing_variable}"
    break
  end

  monkey = monkey_hash[missing_variable]
  raise "Missing monkey: #{missing_variable}" unless monkey
  
  value1, value2 = partly_resolved_monkeys[monkey.value1], partly_resolved_monkeys[monkey.value2]
  raise "Both values are resolved" if value1 && value2
  raise "Neither value is resolved" unless value1 || value2

  m = partly_resolved_monkeys[monkey.name]
  
  raise "Monkey #{monkey.name} is not resolved" unless m

  if value1
    missing_variable = monkey.value2
    case monkey.operator
    when '+'
      value_of_missing_variable = m - value1
    when '-'
      value_of_missing_variable = value1 - m
    when '*'
      value_of_missing_variable = m / value1
    when '/'
      value_of_missing_variable = value1 / m
    else
      raise "Unknown operator #{monkey.operator}"
    end
  else
    missing_variable = monkey.value1
    case monkey.operator
    when '+'
      value_of_missing_variable = m - value2
    when '-'
      value_of_missing_variable = m + value2
    when '*'
      value_of_missing_variable = m / value2
    when '/'
      value_of_missing_variable = m * value2
    else
      raise "Unknown operator #{monkey.operator}"
    end
  end

  partly_resolved_monkeys[missing_variable] = value_of_missing_variable
end
