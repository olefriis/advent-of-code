lines = File.readlines('10/input').map(&:strip)

machine = Struct.new(:expected_lights, :expected_joltage, :buttons)
machines = []
lines.each do |line|
  parts = line.split(' ')
  lights = parts[0][1..-2].chars.map {|c| c == '#'}
  buttons = parts[1..-2].map {|b| b[1..-2].split(',').map(&:to_i)}
  joltage = parts[-1][1..-2].split(',').map(&:to_i)
  machines << machine.new(lights, joltage, buttons)
end

def solve_1(expected_lights, buttons)
  0.upto(buttons.count) do |number_of_buttons|
    buttons.combination(number_of_buttons).each do |button_combination|
      lights = [false] * expected_lights.count
      button_combination.each do |button|
        button.each do |light_index|
          lights[light_index] = !lights[light_index]
        end
      end
      return number_of_buttons if lights == expected_lights
    end
  end

  raise "No solution found"
end

part_1 = machines.sum do |machine|
  solve_1(machine.expected_lights, machine.buttons)
end
puts "Part 1: #{part_1}"

def generate_patterns(buttons, number_of_joltages)
  patterns = {}

  0.upto(buttons.length) do |number_of_buttons|
    buttons.combination(number_of_buttons).each do |button_combination|
      pattern = [0] * number_of_joltages
      button_combination.each do |button|
        button.each {|index| pattern[index] += 1}
      end
      patterns[pattern] ||= button_combination.length
    end
  end

  patterns
end

def solve_2(expected_joltage, buttons, patterns, cache={})
  return 0 if expected_joltage.all?(&:zero?)
  return nil if expected_joltage.any?(&:negative?)

  cache[expected_joltage] ||= patterns.filter_map do |pattern, pattern_cost|
    # Check if pattern is compatible: pattern[i] <= goal[i] and same parity
    next unless pattern.each_with_index.all? { |p, i| p <= expected_joltage[i] && p % 2 == expected_joltage[i] % 2 }

    # Subtract pattern and divide by 2
    new_joltage = expected_joltage.each_with_index.map { |j, i| (j - pattern[i]) / 2 }

    sub_result = solve_2(new_joltage, buttons, patterns, cache)
    next unless sub_result

    pattern_cost + 2 * sub_result
  end.min
end

# This part is based onhttps://www.reddit.com/r/adventofcode/comments/1pk87hl/2025_day_10_part_2_bifurcate_your_way_to_victory/
# I'd never have come up with this myself!
part_2 = machines.each_with_index.sum do |machine, index|
  patterns = generate_patterns(machine.buttons, machine.expected_joltage.length)
  result = solve_2(machine.expected_joltage, machine.buttons, patterns)
  puts "Machine #{index + 1}/#{machines.length}: #{result}"
  result
end
puts "Part 2: #{part_2}"
