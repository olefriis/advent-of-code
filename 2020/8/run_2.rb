Inst = Struct.new(:inst, :param, :has_been_run)
program = File.readlines('input').map do |line|
  raise "Weird line: #{line}" unless line =~ /^(nop|acc|jmp) ([+-]\d+)/
  Inst.new($1, $2.to_i)
end

def run(program)
  program.each { |i| i.has_been_run = false }

  acc = 0
  pc = 0
  while pc < program.count do
    instruction = program[pc]
    if instruction.has_been_run
      return nil
    end
  
    instruction.has_been_run = true
    case instruction.inst
    when 'nop'
      pc += 1
    when 'acc'
      acc += instruction.param
      pc += 1
    when 'jmp'
      pc += instruction.param
    end
  end

  acc
end

program.count.times do |position|
  instruction = program[position]
  if instruction.inst == 'nop'
    program[position] = Inst.new('jmp', instruction.param)
  elsif instruction.inst == 'jmp'
    program[position] = Inst.new('nop', instruction.param)
  end

  result = run(program)
  program[position] = instruction

  if result
    puts "Changed line #{position+1}, got #{result}"
  end
end
