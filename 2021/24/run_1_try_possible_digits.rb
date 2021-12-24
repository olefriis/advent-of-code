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
      begin
        memory[arg1] = memory[arg1] + (memory[instruction.arg2] || instruction.arg2)
      rescue
        binding.pry
      end
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

possible_digits = [[5, 4, 3, 2, 1], [9, 8, 7, 6, 5], [3, 2, 1], [9, 8, 7, 6], [9, 8, 7], [3, 2, 1], [4, 3, 2, 1], [9], [9, 8, 7, 6, 5], [9, 8, 7, 6, 5, 4, 3, 2, 1], [9, 8, 7, 6, 5, 4, 3, 2, 1], [5, 4, 3, 2, 1], [1], [9, 8, 7]]

puts "Checking a total of #{possible_digits.map(&:count).inject(&:*)} combinations"

def recurse_possible_digits(possible_digits, index, input_z, parts)
  possible_digits[index].each do |digit|
    memory = execute(parts[index], [digit], {'z' => input_z})
    if index == possible_digits.length - 1
      if memory['z'] == 0
        puts "Level #{index}: #{digit}"
        binding.pry
        return true
      end
    else
      if recurse_possible_digits(possible_digits, index + 1, memory['z'], parts)
        puts "Level #{index}: #{digit}"
        return true
      end
    end
  end
  false
end
input = [9, 1, 5, 9, 9, 9, 9, 4, 3, 9, 9, 3, 9, 5]

memory = execute(program, input, {})
binding.pry

recurse_possible_digits(possible_digits, 0, 0, parts)
