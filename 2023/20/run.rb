input = File.readlines("20/input").map(&:strip)

Mod = Struct.new(:type, :state, :inputs, :output, :destinations)

def name_of_module(m)
  $modules.each do |name, mod|
    return name if m == mod
  end
end

$modules = {}
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
  $modules[name] = m
  destinations.each do |destination|
    input_connections[destination] ||= []
    input_connections[destination] << name
  end
end

output_modules = []
input_connections.each do |destination, sources|
  output_modules << destination unless $modules[destination]
end

output_modules.each do |m|
  puts "Creating output module #{m}"
  $modules[m] = Mod.new(:output, nil, nil, nil, [])
end

input_connections.each do |destination, sources|
  destination_module = $modules[destination]
  sources.each_with_index do |source, i|
    source_module = $modules[source]
    source_module.destinations << [destination_module, i]
  end
  if destination_module.type == :conjunction
    destination_module.state = sources.map { :low }
    destination_module.inputs = sources.map { :low }
  end
end

$pulses_to_process = []

def process_input(m)
  name = name_of_module(m)
  case m.type
  when :output
    m.state = m.inputs
    m.inputs = nil
  when :broadcaster
    $pulses_to_process << [name, m.inputs]
    m.inputs = nil
  when :flip_flop
    if m.inputs == :low
      m.state = {:on => :off, :off => :on}[m.state]
      output = {:on => :high, :off => :low}[m.state]
      $pulses_to_process << [name, output]
    end
    m.inputs = nil
  when :conjunction
    raise "No input" if m.inputs.none?
    state_before = m.state.dup
    m.inputs.each_with_index do |input, i|
      m.state[i] = input if input
      $conjunction_cycle_counts[i] ||= $cycle_count if name == $name_of_next_to_last_node && input == :high
    end
    output = m.state.all?(:high) ? :low : :high
    $pulses_to_process << [name, output]
    m.inputs.length.times do |i|
      m.inputs[i] = nil
    end
  else
    raise "Invalid type: #{m.type}"
  end
end

def propagate_pulse(source_and_type)
  source_name, pulse = source_and_type
  source_module = $modules[source_name]

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
  $pulses_to_process << ['broadcaster', :low]
  low_pulses_forwarded = 1
  high_pulses_forwarded = 0
  while $pulses_to_process.any?
    pulse = $pulses_to_process.shift
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
rx = $modules['rx']
$name_of_next_to_last_node = $modules.find { |name, m| m.destinations == [[rx, 0]] }.first
$conjunction_cycle_counts = $modules[$name_of_next_to_last_node].state.map { nil }
$cycle_count = 0

low_pulses_forwarded = high_pulses_forwarded = 0
1000.times do
  low_forwarded, high_forwarded = run_cycle
  low_pulses_forwarded += low_forwarded
  high_pulses_forwarded += high_forwarded
end
puts "Part 1: #{low_pulses_forwarded * high_pulses_forwarded}"

$cycle_count = 1001
loop do
  run_cycle
  if $conjunction_cycle_counts.all?
    puts "Part 2: #{$conjunction_cycle_counts.inject(&:lcm)}"
    break
  end
  $cycle_count += 1
end
