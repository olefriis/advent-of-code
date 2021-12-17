class Evaluator
  Packet = Struct.new(:type, :version, :ending_position, :value)

  def initialize(input)
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
    @bits = input.split('').map { |c| mapping[c] }.join('')
    @root_node = parse(0)
  end

  def evaluate
    execute(@root_node)
  end

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
end

def test(input, expected, message)
  actual = Evaluator.new(input).evaluate
  if actual == expected
    puts "PASSED: #{message}"
  else
    puts "FAILED: #{message}"
    puts "  Expected: #{expected}"
    puts "  Actual: #{actual}"
  end
end

test 'C200B40A82', 3, 'sum of 1 and 2'
test '04005AC33890', 54, 'product of 6 and 9'
test '880086C3E88112', 7, 'minimum of 7, 8, and 9'
test 'CE00C43D881120', 9, 'maximum of 7, 8, and 9'
test 'D8005AC2A8F0', 1, '5 is less than 15'
test 'F600BC2D8F', 0, '5 is not greater than 15'
test '9C005AC2F8F0', 0, '5 is not equal to 15'
test '9C0141080250320F1802104A08', 1, '1 + 3 = 2 * 2'

puts Evaluator.new(File.read('input')).evaluate
