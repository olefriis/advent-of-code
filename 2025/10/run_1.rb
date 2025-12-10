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

#p machines

def solve_1(machine)
  levels = 0
  light_configurations = [[false] * machine.expected_lights.count]
  while !light_configurations.include?(machine.expected_lights)
    levels += 1
    new_configurations = []
    light_configurations.each do |configuration|
      machine.buttons.each do |button|
        new_configuration = configuration.dup
        button.each do |light_index|
          new_configuration[light_index] = !new_configuration[light_index]
        end
        new_configurations << new_configuration
      end
    end
    light_configurations = new_configurations.uniq
  end
  levels
end

def solve_2(button_index, buttons, expected_joltage, results)
  key = expected_joltage
  return results[key] if results.key?(key)

  button = buttons[button_index]
  max_number_of_presses = button.map {|light_index| expected_joltage[light_index]}.min

  max_number_of_presses.downto(1) do |presses|
    puts "  Pressing button #{button} #{presses} times. Results: #{results.length}" if button_index == 0
    new_expected_joltage = expected_joltage.dup
    button.each do |light_index|
      new_expected_joltage[light_index] -= presses
    end
    if button_index == buttons.length - 1
      if new_expected_joltage.all? {|j| j == 0}
        results[key] = presses
        return presses
      end
    else
      potential_solution = solve_2(button_index + 1, buttons, new_expected_joltage, results)
      results[key] = potential_solution
      return presses + potential_solution if potential_solution
    end
  end

  results[key] = nil
  nil
end

def solve_2_attempt_2(initial, buttons, joltages, results = {})
  return 0 if joltages.all? {|j| j == 0}

  return results[joltages] if results.key?(joltages)

  # Find the biggest joltage
  max_joltage = joltages.max
  max_joltage_index = joltages.index(max_joltage)
  relevant_buttons = buttons.select {|b| b.include?(max_joltage_index)}.sort_by {|b| -b.length}
  puts "  Solving for joltages #{joltages}, max joltage #{max_joltage} at index #{max_joltage_index}. Relevant buttons: #{relevant_buttons}" if initial

  relevant_buttons.each do |button|
    puts "    Trying button #{button}" if initial
    new_joltages = joltages.dup
    button.each {|i| new_joltages[i] -= 1}
    next if new_joltages.any? {|j| j < 0}
    result = solve_2_attempt_2(false, buttons, new_joltages, results)
    if result
      results[joltages] = 1 + result
      return 1 + result if result
    end
  end

  results[joltages] = nil
  nil
end

part_1 = 0
part_2 = 0
machines.each_with_index do |machine, index|
  puts "Processing machine #{index + 1}/#{machines.count}"
  part_1 += solve_1(machine)
  #value_2 = solve_2(0, machine.buttons.sort_by {|b| -b.length }, machine.expected_joltage, {})
  value_2 = solve_2_attempt_2(true, machine.buttons, machine.expected_joltage)
  puts "  Part 2 value: #{value_2}"
  part_2 += value_2
end

puts "Part 1: #{part_1}"
puts "Part 2: #{part_2}"
