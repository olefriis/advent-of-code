require 'pry'

lines = File.readlines('input').map(&:strip)

lines_with_classifiers = lines[0..lines.index('')-1]
my_ticket = lines[lines_with_classifiers.count + 1]
nearby_tickets = lines[(lines_with_classifiers.count + 4)..-1]

Interval = Struct.new(:name, :first_low, :first_high, :second_low, :second_high) do
  def matches?(number)
    (number >= first_low && number <= first_high) || (number >= second_low && number <= second_high)
  end
end

intervals = lines_with_classifiers.map do |line|
  raise "Weird line: #{line}" unless line =~ /^(.*)\: (\d+)-(\d+) or (\d+)-(\d+)$/
  Interval.new($1, $2.to_i, $3.to_i, $4.to_i, $5.to_i)
end

error_rate = 0
nearby_tickets.each do |ticket|
  error_rate += ticket.split(',').map(&:to_i).select do |number|
    intervals.none? {|interval| interval.matches?(number)}
  end.sum
end

puts error_rate
