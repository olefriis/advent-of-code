class Evaluator
  Packet = Struct.new(:type, :version, :sub_packets, :value) do
    def evaluate
      values = sub_packets.map(&:evaluate)

      case type
      when 0 # Sum
        values.inject(&:+)
      when 1 # Product
        values.inject(&:*)
      when 2 # Minimum
        values.min
      when 3 # Maximum
        values.max
      when 4 # Literal
        value
      when 5 # Greater than
        values[0] > values[1] ? 1 : 0
      when 6 # Less than
        values[0] < values[1] ? 1 : 0
      when 7 # Equal
        values[0] == values[1] ? 1 : 0
      else
        raise "Unknown node type: #{node.type}"
      end
    end
  end

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
    @position = 0
    @root_node = parse
  end

  def evaluate
    @root_node.evaluate
  end

  private
  def parse
    version = consume(3).to_i(2)
    packet_type = consume(3).to_i(2)
    if packet_type == 4
      literal_value_bits = ''
      loop do
        group = consume(5)
        literal_value_bits += group[1..-1]
        break if group[0] == '0'
      end
      value = literal_value_bits.to_i(2)
      Packet.new(packet_type, version, [], value)
    else
      length_type_id = consume(1)
      if length_type_id == '0'
        sub_packets_length = consume(15).to_i(2)
        start_position_of_sub_packets = @position
        sub_packets = []
        while @position < start_position_of_sub_packets + sub_packets_length
          sub_packet = parse
          sub_packets << sub_packet
        end
        Packet.new(packet_type, version, sub_packets, nil)
      else
        number_of_sub_packets = consume(11).to_i(2)
        sub_packets = []
        number_of_sub_packets.times do
          sub_packet = parse
          sub_packets << sub_packet
        end
        Packet.new(packet_type, version, sub_packets, nil)
      end
    end
  end

  def consume(length)
    result = @bits[@position...@position+length]
    @position += length
    result
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
