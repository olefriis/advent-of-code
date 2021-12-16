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

@version_number_sum = 0
def parse(position)
  version_bits = @bits[position...(position+3)]
  version = version_bits.to_i(2)
  @version_number_sum += version
  position += 3
  packet_type_id = @bits[position...(position+3)]
  position += 3
  if packet_type_id == '100'
    literal_value_bits = ''
    loop do
      group = @bits[position...(position+5)]
      position += 5
      group_starts_with = group[0]
      literal_value_bits += group[1..-1]
      break if group_starts_with == '0'
    end
    value = literal_value_bits.to_i(2)
    Packet.new('literal', version, position, value)
  else #if ['011', '110'].include?(packet_type_id)
    length_type_id = @bits[position...(position+1)]
    position += 1
    if length_type_id == '0'
      sub_packets_length_bits = @bits[position...(position+15)]
      sub_packet_length = sub_packets_length_bits.to_i(2)
      position += 15
      start_position_of_sub_packets = position
      sub_packets = []
      loop do
        sub_packet = parse(position)
        sub_packets << sub_packet
        position = sub_packet.ending_position
        break if position == start_position_of_sub_packets + sub_packet_length
      end
      Packet.new('operator', version, position, sub_packets)
    else
      number_of_sub_packets_bits = @bits[position...(position+11)]
      number_of_sub_packets = number_of_sub_packets_bits.to_i(2)
      position += 11
      sub_packets = []
      number_of_sub_packets.times do
        sub_packet = parse(position)
        sub_packets << sub_packet
        position = sub_packet.ending_position
      end
      Packet.new('operator', version, position, sub_packets)
    end
  end
end

parse 0
puts @version_number_sum
