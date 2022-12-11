require 'pry'
Monkey = Struct.new(:items, :operation, :divisible_by_test, :monkey_true, :monkey_false)

monkeys = File.read('11/input').split("\n\n")
  .map do |monkey|
    lines = monkey.lines.map(&:chomp)
    items = lines[1].split(': ').last.split(', ').map(&:to_i)
    operation = lines[2].split('new = ').last
    divisible_by_test = lines[3].split('divisible by ').last.to_i
    monkey_true = lines[4].split(' ').last.to_i
    monkey_false = lines[5].split(' ').last.to_i
    Monkey.new(items, operation, divisible_by_test, monkey_true, monkey_false)
  end
inspections = [0] * monkeys.size
big_modulo = monkeys.map(&:divisible_by_test).inject(&:*)

10000.times do |time|
  monkeys.each_with_index do |monkey, idx|
    inspections[idx] += monkey.items.size
    monkey.items.each do |old|
      worry_level = eval(monkey.operation) % big_modulo
      destination_monkey = worry_level % monkey.divisible_by_test == 0 ?
        monkey.monkey_true : monkey.monkey_false
      monkeys[destination_monkey].items << worry_level
    end
    monkey.items.clear
  end
end

monkey_business = inspections.max(2).inject(&:*)
puts "Part 2: #{monkey_business}"
