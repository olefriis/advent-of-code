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
  result = []
  initial_lights = [false] * expected_lights.count
  0.upto(buttons.count) do |number_of_buttons|
    buttons.combination(number_of_buttons).each do |button_combination|
      current_lights = initial_lights.dup
      button_combination.each do |button|
        button.each do |light_index|
          current_lights[light_index] = !current_lights[light_index]
        end
      end
      result << button_combination if current_lights == expected_lights
    end
  end

  result
end

part_1 = machines.sum do |machine|
  solve_1(machine.expected_lights, machine.buttons).first.length
end
puts "Part 1: #{part_1}"

def solve_2(expected_joltage, buttons, debug)
  puts "Solving for expected_joltage: #{expected_joltage}" if debug

  return nil if expected_joltage.any?(&:negative?)
  return 0 if expected_joltage.all?(&:zero?)

  if expected_joltage.any?(&:odd?)
    light_configuration = expected_joltage.map(&:odd?)
    button_combinations = solve_1(light_configuration, buttons)
    # Find the combinations that work
    working = []
    button_combinations.each do |button_combination|
      new_expected_joltage = expected_joltage.dup
      button_combination.each do |button|
        button.each { |idx| new_expected_joltage[idx] -= 1 }
      end
      sub_result = solve_2(new_expected_joltage, buttons, debug)
      working << button_combination.length + sub_result if sub_result
    end
    puts "Nothing worked!" if debug && working.empty?
    working.min
  else
    sub_result = solve_2(expected_joltage.map { |j| j / 2 }, buttons, debug)
    sub_result ? sub_result * 2 : nil
  end
end

part_2 = machines.each_with_index.sum do |machine, index|
  puts "Solving machine #{index + 1}/#{machines.length}..."
  result = solve_2(machine.expected_joltage, machine.buttons, index == 124)
  p result
  result
end
puts "Part 2: #{part_2}"
