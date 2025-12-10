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
  return 0 if expected_joltage.all? {|j| j == 0}
  return nil if button_index >= buttons.length

  button = buttons[button_index]
  max_number_of_presses = button.map {|light_index| expected_joltage[light_index]}.min

  max_number_of_presses.downto(0) do |presses|
    puts "  Pressing button #{button} #{presses} times" if button_index == 0
    new_expected_joltage = expected_joltage.dup
    button.each do |light_index|
      new_expected_joltage[light_index] -= presses
    end
    potential_solution = solve_2(button_index + 1, buttons, new_expected_joltage)
    return presses + potential_solution if potential_solution
  end

  nil
end

part_1 = 0
machines.each_with_index do |machine|
  part_1 += solve_1(machine)
end
puts "Part 1: #{part_1}"

part_2 = 0
machines.each_with_index do |machine, index|
  puts "Processing machine #{index + 1}/#{machines.count}"
  part_2 += solve_2(0, machine.buttons.sort_by {|b| -b.length }, machine.expected_joltage)
end
puts "Part 2: #{part_2}"
