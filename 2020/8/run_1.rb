Inst = Struct.new(:inst, :param, :has_been_run)
program = File.readlines('input').map do |line|
  raise "Weird line: #{line}" unless line =~ /^(nop|acc|jmp) ([+-]\d+)/
  Inst.new($1, $2.to_i, false)
end

acc = 0
pc = 0
loop do
  instruction = program[pc]
  if instruction.has_been_run
    puts "acc is #{acc}"
    exit
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
