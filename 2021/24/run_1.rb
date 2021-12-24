require 'pry'
require 'set'

Instruction = Struct.new(:operator, :arg1, :arg2)

def parse(lines)
  lines.map do |line|
    operator = line.split(' ').first
    arg1 = line.split(' ')[1]
    arg2 = line.split(' ')[-1]
    if ['w', 'x', 'y', 'z'].include?(arg2)
      Instruction.new(operator, arg1, arg2)
    else
      # Cheat: Do .to_i now
      Instruction.new(operator, arg1, arg2.to_i)
    end
  end
end

program = parse(File.readlines('input').map(&:strip))

def execute(program, input, input_memory={})
  memory = {
    'w' => 0,
    'x' => 0,
    'y' => 0,
    'z' => 0
  }.merge(input_memory)

  program.each do |instruction|
    arg1 = instruction.arg1
    case instruction.operator
    when 'inp'
      memory[arg1] = input.shift
    when 'add'
      memory[arg1] = memory[arg1] + (memory[instruction.arg2] || instruction.arg2)
    when 'mul'
      memory[arg1] = memory[arg1] * (memory[instruction.arg2] || instruction.arg2)
    when 'div'
      memory[arg1] = memory[arg1] / (memory[instruction.arg2] || instruction.arg2)
    when 'mod'
      memory[arg1] = memory[arg1] % (memory[instruction.arg2] || instruction.arg2)
    when 'eql'
      memory[arg1] = memory[arg1] == (memory[instruction.arg2] || instruction.arg2) ? 1 : 0
    end
  end

  memory
end

def program_parts(program)
  result = []
  current_instructions = nil
  program.each do |instruction|
    if instruction.operator == 'inp'
      result << current_instructions if current_instructions
      current_instructions = []
    end
    current_instructions << instruction
  end
  result << current_instructions
  result
end

parts = program_parts(program)


inputs_and_memory_states_for_parts = []

memory_states_to_try = Set.new()
# First input: Try starting with z=0
parts_to_memories = []
memory_states_to_try.add(0)
output_states_back_to_digit_and_input_z_for_each_part = []
i=0
parts.each do |program_part|
  puts "Part #{i}"

  if i == 0
    previous_output_states_back_to_digit_and_input_z = Set.new
    previous_output_states_back_to_digit_and_input_z << [0, 0]
  else
    previous_output_states = output_states_back_to_digit_and_input_z_for_each_part[i-1]
  end
  i += 1

  output_states_back_to_digit_and_input_z = Hash.new { |h, k| h[k] = Set.new }
  9.downto(1) do |digit|
    input_to_output_memory = []
    memory_states_to_try.each do |memory_z|
      # Only z is used in the next part, so only care about that
      input_memory = {'z' => memory_z}
      resulting_memory = execute(program_part, [digit], input_memory)
      resulting_memory_z = resulting_memory['z']

      output_states_back_to_digit_and_input_z[resulting_memory_z] << [digit, memory_z]
    end
  end
  
  output_states_back_to_digit_and_input_z_for_each_part << output_states_back_to_digit_and_input_z
  memory_states_to_try = output_states_back_to_digit_and_input_z.keys
  puts "Ended up with #{memory_states_to_try.count} memory states"
end

wanted_zs = [0]
# Just testing
#wanted_zs = [output_states_back_to_digit_and_input_z_for_each_part.last.keys.first]
puts "Want to go from z=#{wanted_zs.join(',')}"

total_possible_digits = []
(output_states_back_to_digit_and_input_z_for_each_part.length - 1).downto(0) do |i|
  new_wanted_zs = []
  possible_digits = []
  wanted_zs.each do |wz|
    output_states_back_to_digit_and_input_z_for_each_part[i][wz].each do |digit_and_input_z|
      possible_digits << digit_and_input_z[0]
      new_wanted_zs << digit_and_input_z[1]
    end
  end
  wanted_zs = new_wanted_zs.uniq
  puts "Possible digits: #{possible_digits.uniq.join(',')}"
  total_possible_digits << possible_digits.uniq
  puts "We have #{new_wanted_zs.length} new wanted z's: #{new_wanted_zs.join(',')}"
end

puts "Possible digits: #{total_possible_digits}"
binding.pry

# Gives these possible digits:
# Possible digits: [[5, 4, 3, 2, 1], [9, 8, 7, 6, 5], [3, 2, 1], [9, 8, 7, 6], [9, 8, 7], [3, 2, 1], [4, 3, 2, 1], [9], [9, 8, 7, 6, 5], [9, 8, 7, 6, 5, 4, 3, 2, 1], [9, 8, 7, 6, 5, 4, 3, 2, 1], [5, 4, 3, 2, 1], [1], [9, 8, 7]]

exit

def check_input(program, numbers)
  show_output = numbers[10] == 1
  memory = execute(program, numbers)
  p memory if show_output
  memory['z'] == 0
end

def lower(number)
  (number.length-1).downto(0) do |i|
    if number[i] == 1
      number[i] = 9
    else
      number[i] -= 1
      break
    end
  end
end

number = [9] * 14
#number = '99999999544411'.split.map(&:to_i)

loop do
  if check_input(lines, number.dup)
    puts number.join.to_i
    exit
  end
  if number[10] == 1
    puts number.join
  end
  lower(number)
end
#execute(lines, [8])
