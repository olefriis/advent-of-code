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

def solve_2(button_index, buttons, expected_joltage)
  debug = button_index == 0

  return 0 if expected_joltage.all? {|j| j == 0}
  raise "Hey! Negative joltage! #{expected_joltage}" if expected_joltage.any? {|j| j < 0}
  return nil if button_index >= buttons.length

  puts "Original joltages: #{expected_joltage}" if debug

  smart_counts = 0
  loop do
    count, new_joltages = find_button_that_must_be_pressed(buttons, expected_joltage, button_index == 0)
    break if count == 0

    return nil if count == -1 # Impossible!

    puts "  Must press a button #{count} times" if debug
    expected_joltage = new_joltages
    smart_counts += count
  end

  puts "New joltages: #{expected_joltage}" if debug

  button = buttons[button_index]
  max_number_of_presses = button.map {|light_index| expected_joltage[light_index]}.min

  max_number_of_presses.downto(0) do |presses|
    puts "  Pressing button #{button} #{presses} times" if debug
    new_expected_joltage = expected_joltage.dup
    button.each do |light_index|
      new_expected_joltage[light_index] -= presses
    end
    potential_solution = solve_2(button_index + 1, buttons, new_expected_joltage)
    return smart_counts + presses + potential_solution if potential_solution
  end

  nil
end

def find_button_that_must_be_pressed(buttons, expected_joltage, debug)
  expected_joltage.each_with_index do |joltage, index|
    expected_joltage.each_with_index do |other_joltage, other_index|
      next if index == other_index
      next if joltage <= other_joltage

      buttons_targeting_first_but_not_other_joltage = buttons.select do |button|
        button.include?(index) && !button.include?(other_index)
      end
      next unless buttons_targeting_first_but_not_other_joltage.length == 1
      necessary_button = buttons_targeting_first_but_not_other_joltage.first
      necessary_times = joltage - other_joltage

      new_joltages = expected_joltage.dup
      necessary_button.each do |light_index|
        new_joltages[light_index] -= necessary_times
      end
      if new_joltages.any? {|j| j < 0}
        # Impossible!
        return [-1, []]
      end
      puts " Original joltages: #{expected_joltage}" if debug
      puts " Must press button #{necessary_button} #{necessary_times} times to reduce joltage at index #{index} from #{joltage} to #{other_joltage} (at index #{other_index})" if debug
      return [necessary_times, new_joltages]
    end
  end
  [0, expected_joltage]
end

part_1 = 0
machines.each_with_index do |machine|
  part_1 += solve_1(machine)
end
puts "Part 1: #{part_1}"

part_2 = 0
machines.each_with_index do |machine, index|
  puts "Processing machine #{index + 1}/#{machines.count}"
  value_2 = solve_2(0, machine.buttons.sort_by {|b| -b.length }, machine.expected_joltage)
  puts "  Part 2 value for machine #{index + 1}: #{value_2}"
  part_2 += value_2
end
puts "Part 2: #{part_2}"
