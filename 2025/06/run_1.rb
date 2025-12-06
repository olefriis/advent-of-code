lines = File.readlines('06/input').map(&:strip)

columns = lines.map {|line| line.split(' ')}
operations = columns.last
numbers = columns[0..-2].map {|col| col.map(&:to_i)}

result_1 = numbers[0]
numbers[1..-1].each do |row|
  operations.each_with_index do |op, idx|
    case op
    when '+'
      result_1[idx] += row[idx]
    when '*'
      result_1[idx] *= row[idx]
    else
      raise "Unknown operation: #{op}"
    end
  end
end

puts "Part 1: #{result_1.sum}"
