input = File.readlines("20/input").map(&:strip)

Mod = Struct.new(:type, :state, :inputs, :output, :destinations)

def name_of_module(m)
  MODULES.each do |name, mod|
    return name if m == mod
  end
end

MODULES = {}
input_connections = {} # For each module, an ordered list of names of the input modules

input.each do |line|
  line =~ /^(.*) -> (.*)$/ or raise "Invalid line: #{line}"
  name_and_type, destinations = $1, $2.split(',').map(&:strip)
  name = type = m = nil
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

def process_input(m)
  name = name_of_module(m)
  case m.type
  when :output
    m.state = m.inputs
    m.inputs = nil
  when :broadcaster
    PULSES_TO_PROCESS << [name, m.inputs]
    m.inputs = nil
  when :flip_flop
    if m.inputs == :low
      m.state = {:on => :off, :off => :on}[m.state]
      output = {:on => :high, :off => :low}[m.state]
      PULSES_TO_PROCESS << [name, output]
    end
    m.inputs = nil
  when :conjunction
    raise "No input" if m.inputs.none?
    state_before = m.state.dup
    m.inputs.each_with_index do |input, i|
      m.state[i] = input if input
      CONJUNCTION_CYCLE_COUNTS[i] ||= CYCLE_COUNT[0] if name == NAME_OF_NEXT_TO_LAST_NODE && input == :high
    end
    output = m.state.all?(:high) ? :low : :high
    PULSES_TO_PROCESS << [name, output]
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
    when :output, :flip_flop
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
  low_pulses_forwarded = 1
  high_pulses_forwarded = 0
  while PULSES_TO_PROCESS.any?
    pulse = PULSES_TO_PROCESS.shift
    pulses_propagated = propagate_pulse(pulse)
    case pulse.last
    when :low
      low_pulses_forwarded += pulses_propagated
    when :high
      high_pulses_forwarded += pulses_propagated
    else
      raise "Invalid pulse: #{pulse}"
    end
  end
  [low_pulses_forwarded, high_pulses_forwarded]
end

# For part 2, the 'rx' node gets its input from a conjunction node. If we watch the inputs from that
# conjunction node and find the cycles between each of the inputs turning "high", we can find the
# number of iterations required to get all the inputs to "high" at the same time.
rx = MODULES['rx']
NAME_OF_NEXT_TO_LAST_NODE = MODULES.find { |name, m| m.destinations == [[rx, 0]] }.first
CONJUNCTION_CYCLE_COUNTS = MODULES[NAME_OF_NEXT_TO_LAST_NODE].state.map { nil }
CYCLE_COUNT = [0] # Hack...

low_pulses_forwarded = high_pulses_forwarded = 0
1000.times do
  low_forwarded, high_forwarded = run_cycle
  low_pulses_forwarded += low_forwarded
  high_pulses_forwarded += high_forwarded
end
puts "Part 1: #{low_pulses_forwarded * high_pulses_forwarded}"

CYCLE_COUNT[0] = 1001
loop do
  run_cycle
  if CONJUNCTION_CYCLE_COUNTS.all?
    puts "Part 2: #{CONJUNCTION_CYCLE_COUNTS.inject(&:lcm)}"
    break
  end
  CYCLE_COUNT[0] += 1
end
