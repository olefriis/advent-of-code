Monkey = Struct.new(:items, :operation, :divisible_by_test, :monkey_true, :monkey_false) do
  def initialize(*args)
    super
    instance_eval("def self.do_operation(old); #{operation}; end")
  end
end

def solve(iterations, worry_division)
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

  iterations.times do |time|
    monkeys.each_with_index do |monkey, idx|
      inspections[idx] += monkey.items.size
      monkey.items.each do |old|
        worry_level = (eval(monkey.operation) / worry_division) % big_modulo
        destination_monkey = worry_level % monkey.divisible_by_test == 0 ?
          monkey.monkey_true : monkey.monkey_false
        monkeys[destination_monkey].items << worry_level
      end
      monkey.items.clear
    end
  end

  inspections.max(2).inject(&:*)
end

puts "Part 1: #{solve(20, 3)}"
puts "Part 2: #{solve(10000, 1)}"
