chars = File.read('input').strip.split('')

mapping = {
  '0' => '0000',
  '1' => '0001',
  '2' => '0010',
  '3' => '0011',
  '4' => '0100',
  '5' => '0101',
  '6' => '0110',
  '7' => '0111',
  '8' => '1000',
  '9' => '1001',
  'A' => '1010',
  'B' => '1011',
  'C' => '1100',
  'D' => '1101',
  'E' => '1110',
  'F' => '1111'
}
@bits = chars.map { |c| mapping[c] }.join('')

Packet = Struct.new(:type, :version, :ending_position, :value)

def parse(position)
  version = @bits[position...(position+3)].to_i(2)
  position += 3
  packet_type = @bits[position...(position+3)].to_i(2)
  position += 3
  if packet_type == 4
    literal_value_bits = ''
    loop do
      group = @bits[position...(position+5)]
      position += 5
      group_starts_with = group[0]
      literal_value_bits += group[1..-1]
      break if group_starts_with == '0'
    end
    value = literal_value_bits.to_i(2)
    Packet.new(packet_type, version, position, value)
  else
    length_type_id = @bits[position...(position+1)]
    position += 1
    if length_type_id == '0'
      sub_packets_length = @bits[position...(position+15)].to_i(2)
      position += 15
      start_position_of_sub_packets = position
      sub_packets = []
      while position < start_position_of_sub_packets + sub_packets_length
        sub_packet = parse(position)
        sub_packets << sub_packet
        position = sub_packet.ending_position
      end
      Packet.new(packet_type, version, position, sub_packets)
    else
      number_of_sub_packets = @bits[position...(position+11)].to_i(2)
      position += 11
      sub_packets = []
      number_of_sub_packets.times do
        sub_packet = parse(position)
        sub_packets << sub_packet
        position = sub_packet.ending_position
      end
      Packet.new(packet_type, version, position, sub_packets)
    end
  end
end

def execute(node)
  case node.type
  when 0 # Sum
    node.value.map { |sub_packet| execute(sub_packet) }.inject(&:+)
  when 1 # Product
    node.value.map { |sub_packet| execute(sub_packet) }.inject(&:*)
  when 2 # Minimum
    node.value.map { |sub_packet| execute(sub_packet) }.min
  when 3 # Maximum
    node.value.map { |sub_packet| execute(sub_packet) }.max
  when 4 # Literal
    node.value
  when 5 # Greater than
    value_1 = execute(node.value[0])
    value_2 = execute(node.value[1])
    value_1 > value_2 ? 1 : 0
  when 6 # Less than
    value_1 = execute(node.value[0])
    value_2 = execute(node.value[1])
    value_1 < value_2 ? 1 : 0
  when 7 # Equal
    value_1 = execute(node.value[0])
    value_2 = execute(node.value[1])
    value_1 == value_2 ? 1 : 0
  else
    raise "Unknown node type: #{node.type}"
  end
end

tree = parse 0
puts execute(tree)
