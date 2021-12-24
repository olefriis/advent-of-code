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

# Chop up the program into parts, each of them starting with an 'inp' instruction
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

EXHAUSTED_MEMORY_STATES = []
14.times do |i|
  EXHAUSTED_MEMORY_STATES << Set.new
end

WINNING_DIGITS = []

def recurse_digits(parts, index, input_z, wanted_z)
  return false if EXHAUSTED_MEMORY_STATES[index].include?(input_z)

  1.upto(9) do |digit|
    memory = execute(parts[index], [digit], {'z' => input_z})
    if index == parts.length - 1
      if memory['z'] == wanted_z
        WINNING_DIGITS << digit
        return true 
      end
    else
      if recurse_digits(parts, index + 1, memory['z'], wanted_z)
        WINNING_DIGITS << digit
        return true
      end
    end
  end

  # We've exhausted input z's at this position
  EXHAUSTED_MEMORY_STATES[index] << input_z
  false
end

recurse_digits(parts, 0, 0, 0)
puts WINNING_DIGITS.reverse.join
