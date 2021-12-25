# Experiment with "JITting" the program parts, just for fun.
# Cuts my "part 1" execution time from 55s to about 8s.

require 'set'

Instruction = Struct.new(:operator, :arg1, :arg2)

def compile(program, name)
  variable_names = ['x', 'y', 'z', 'w']
  s = "def #{name}(input, memory)\n"
  s << "  x, y, z, w = memory['x'], memory['y'], memory['z'], memory['w']\n"
  program.each do |instruction|
    case instruction.operator
    when 'inp'
      s << "  #{instruction.arg1} = input.shift\n"
    when 'add'
      s << "  #{instruction.arg1} += #{instruction.arg2}\n"
    when 'mul'
      s << "  #{instruction.arg1} *= #{instruction.arg2}\n"
    when 'div'
      s << "  #{instruction.arg1} /= #{instruction.arg2}\n"
    when 'mod'
      s << "  #{instruction.arg1} %= #{instruction.arg2}\n"
    when 'eql'
      s << "  #{instruction.arg1} = #{instruction.arg1} == #{instruction.arg2} ? 1 : 0\n"
    end
  end
  s << "  { 'x' => x, 'y' => y, 'z' => z, 'w' => w }\n"
  s << "end\n"

  eval(s)
end

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
parts.each_with_index { |part, index| compile(part, "part_#{index}") }

EXHAUSTED_MEMORY_STATES = []
14.times do |i|
  EXHAUSTED_MEMORY_STATES << Set.new
end

WINNING_DIGITS = []
PART_NAMES = 14.times.map { |i| "part_#{i}".to_sym }

def recurse_digits(parts, index, input_z, wanted_z)
  return false if EXHAUSTED_MEMORY_STATES[index].include?(input_z)

  9.downto(1) do |digit|
    memory = send(PART_NAMES[index], [digit], {'x' => 0, 'y' => 0, 'z' => input_z, 'w' => 0})
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
