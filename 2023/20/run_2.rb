require 'pry'
input = File.readlines("20/input").map(&:strip)

Mod = Struct.new(:type, :state, :inputs, :output, :destinations)

input_connections = {} # For each module, an ordered list of names of the input modules
MODULES = {}

def debug?
  false
end

def name_of_module(m)
  MODULES.each do |name, mod|
    return name if m == mod
  end
end

input.each do |line|
  line =~ /^(.*) -> (.*)$/ or raise "Invalid line: #{line}"
  name_and_type, destinations = $1, $2.split(',').map(&:strip)
  name = nil
  type = nil
  m = nil
  if name_and_type == 'broadcaster'
    name, type, state = 'broadcaster', :broadcaster, :high
  elsif name_and_type.start_with?('%')
    name, type, state = name_and_type[1..-1], :flip_flop, :off
  elsif name_and_type.start_with?('&')
    name, type, state = name_and_type[1..-1], :conjunction, :low
  else
    raise "Invalid name and type: #{name_and_type}"
  end
  m = Mod.new(type, state, nil, :low, [])
  MODULES[name] = m
  destinations.each do |destination|
    input_connections[destination] ||= []
    input_connections[destination] << name
  end
end

output_modules = []
input_connections.each do |destination, sources|
  output_modules << destination unless MODULES[destination]
end

output_modules.each do |m|
  puts "Creating output module #{m}"
  MODULES[m] = Mod.new(:output, nil, nil, nil, [])
end

input_connections.each do |destination, sources|
  destination_module = MODULES[destination]
  sources.each_with_index do |source, i|
    source_module = MODULES[source]
    source_module.destinations << [destination_module, i]
  end
  if destination_module.type == :conjunction
    destination_module.state = sources.map { :low }
    destination_module.inputs = sources.map { :low }
  end
end

PULSES_TO_PROCESS = []
CYCLE_NUMBER = [0]
QL_CYCLE_COUNTS = [nil, nil, nil, nil]

def add_output(name, pulse)
  m = MODULES[name]
  PULSES_TO_PROCESS << [name, pulse]
end

def process_input(m)
  name = name_of_module(m)
  case m.type
  when :output
    m.state = m.inputs
    puts "Output #{name} state #{m.state}" if debug?
    m.inputs = nil
  when :broadcaster
    add_output(name, m.inputs)
    m.inputs = nil
  when :flip_flop
    if m.inputs == :low
      m.state = {:on => :off, :off => :on}[m.state]
      output = {:on => :high, :off => :low}[m.state]
      add_output(name, output)
    end
    m.inputs = nil
  when :conjunction
    raise "No input" if m.inputs.none?
    state_before = m.state.dup
    m.inputs.each_with_index do |input, i|
      m.state[i] = input if input
      QL_CYCLE_COUNTS[i] ||= CYCLE_NUMBER[0] if name == 'ql' && input == :high
    end
    output = m.state.all?(:high) ? :low : :high
    add_output(name, output)
    m.inputs.length.times do |i|
      m.inputs[i] = nil
    end
  else
    raise "Invalid type: #{m.type}"
  end
end

def propagate_pulse(source_and_type)
  source_name, pulse = source_and_type
  source_module = MODULES[source_name]

  source_module.destinations.each do |destination, i|
    case destination.type
    when :output
      destination.inputs = pulse
    when :flip_flop
      destination.inputs = pulse
    when :conjunction
      destination.inputs[i] = pulse
    end
    process_input(destination)
  end
  source_module.destinations.count
end

def run_cycle
  PULSES_TO_PROCESS << ['broadcaster', :low]
  while PULSES_TO_PROCESS.any?
    pulse = PULSES_TO_PROCESS.shift
    source, type = pulse
    propagate_pulse(pulse)
  end
end

cycle = 0
loop do
  cycle += 1
  CYCLE_NUMBER[0] = cycle # hack
  puts cycle if cycle % 1000 == 0
  run_cycle

  if QL_CYCLE_COUNTS.all?
    puts "Part 2: #{QL_CYCLE_COUNTS.inject(&:lcm)}"
    exit
  end
end
