lines = File.readlines('10/input').map(&:strip)

machine = Struct.new(:expected_lights, :expected_joltage, :buttons)
machines = []
lines.each do |line|
  parts = line.split(' ')
  lights = parts[0][1..-2].chars.map {|c| c == '#' ? 1 : 0}
  buttons = parts[1..-2].map {|b| b[1..-2].split(',').map(&:to_i)}
  joltage = parts[-1][1..-2].split(',').map(&:to_i)
  machines << machine.new(lights, joltage, buttons)
end

def generate_patterns(buttons, number_of_joltages)
  patterns = {}

  0.upto(buttons.length) do |number_of_buttons|
    buttons.combination(number_of_buttons).each do |button_combination|
      pattern = [0] * number_of_joltages
      button_combination.each do |button|
        button.each {|index| pattern[index] += 1}
      end
      parity_pattern = pattern.map { |i| i % 2 }
      patterns[parity_pattern] ||= {}
      patterns[parity_pattern][pattern] ||= number_of_buttons
    end
  end

  patterns
end

# This part is based onhttps://www.reddit.com/r/adventofcode/comments/1pk87hl/2025_day_10_part_2_bifurcate_your_way_to_victory/
# I'd never have come up with this myself!
def solve_2(expected_joltage, buttons, patterns, cache={})
  return 0 if expected_joltage.all?(&:zero?)
  return nil if expected_joltage.any?(&:negative?)

  parity_pattern = expected_joltage.map { |j| j % 2 }
  return nil unless patterns.key?(parity_pattern)

  cache[expected_joltage] ||= patterns[parity_pattern].filter_map do |pattern, pattern_cost|
    # Check if pattern is compatible: pattern[i] <= goal[i] and same parity
    next unless pattern.each_with_index.all? { |p, i| p <= expected_joltage[i] && p % 2 == expected_joltage[i] % 2 }

    # Subtract pattern and divide by 2
    new_joltage = expected_joltage.each_with_index.map { |j, i| (j - pattern[i]) / 2 }

    sub_result = solve_2(new_joltage, buttons, patterns, cache)
    next unless sub_result

    pattern_cost + 2 * sub_result
  end.min
end

part_1, part_2 = machines.reduce([0, 0]) do |(part_1_total, part_2_total), machine|
  patterns = generate_patterns(machine.buttons, machine.expected_lights.length)
  [
    part_1_total + patterns[machine.expected_lights].values.min,
    part_2_total + solve_2(machine.expected_joltage, machine.buttons, patterns)
  ]
end
puts "Part 1: #{part_1}"
puts "Part 2: #{part_2}"
