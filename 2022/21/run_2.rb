lines = File.readlines('21/input', chomp: true)
resolved_monkeys = {}
Monkey = Struct.new(:name, :value, :operator, :value1, :value2)

monkeys = {}
lines.each do |line|
  raise 'Invalid line' unless line =~ /(.*): (.*)/
  name, expression = $1, $2
  if expression =~ /^\d+$/
    monkeys[name] = Monkey.new(name, expression.to_i, nil, nil, nil)
  else
    value1, operator, value2 = expression.split(' ')
    monkeys[name] = Monkey.new(name, nil, operator, value1, value2)
  end
end

def calculate_monkey(monkey_name, monkeys)
  monkey = monkeys[monkey_name]
  return nil unless monkey
  return monkey.value if monkey.value

  value1, value2 = calculate_monkey(monkey.value1, monkeys), calculate_monkey(monkey.value2, monkeys)
  value1 && value2 ? eval("#{value1} #{monkey.operator} #{value2}") : nil
end

puts "Part 1: #{calculate_monkey('root', monkeys)}"

monkeys.delete('humn')
root = monkeys['root']
value1, value2 = calculate_monkey(root.value1, monkeys), calculate_monkey(root.value2, monkeys)
desired_name = value1 ? root.value2 : root.value1
desired_value = value1 || value2

while desired_name != 'humn'
  monkey = monkeys[desired_name]
  value1, value2 = calculate_monkey(monkey.value1, monkeys), calculate_monkey(monkey.value2, monkeys)

  raise 'Expected at least one sub-expression to return' unless value1 || value2
  raise 'Did not expect both sug-expressions to return' if value1 && value2

  desired_value = case monkey.operator
  when '+'
    desired_value - (value1 || value2)
  when '*'
    desired_value / (value1 || value2)
  when '-'
    value1 ? value1 - desired_value : desired_value + value2
  when '/'
    value1 ? value1 / desired_value : desired_value * value2
  else
    raise "Unknown operator #{monkey.operator}"
  end
  desired_name = value1 ? monkey.value2 : monkey.value1
end

puts "Part 2: #{desired_value}"
