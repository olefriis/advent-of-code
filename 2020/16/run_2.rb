require 'pry'
require 'set'

lines = File.readlines('input').map(&:strip)

lines_with_classifiers = lines[0..lines.index('')-1]
my_ticket = lines[lines_with_classifiers.count + 2]
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

valid_tickets = nearby_tickets.reject do |ticket|
  ticket.split(',').map(&:to_i).any? {|number| intervals.none? {|interval| interval.matches?(number)} }
end
valid_tickets << my_ticket

classifiers_with_matching_columns = intervals.map do |interval|
  result = Set.new
  # Begin by asserting that all columns are valid everywhere
  valid_tickets.first.split(',').count.times {|value| result << value}
  result
end

=begin valid_intervals_for_columns = []
20.times do |column_index|
  column_values = valid_tickets.map do |ticket|
    column = ticket.split(',').map(&:to_i)[column_index]
  end

  valid_intervals_for_columns << intervals.select do |interval|
    column_values.all? {|value| interval.matches?(value)}
  end
end

binding.pry
=end

valid_tickets.each do |ticket|
  values = ticket.split(',').map(&:to_i)
  values.each_with_index do |value, value_index|
    classifiers_with_matching_columns.each_with_index do |classifier_with_matching_column, classifier_index|
      classifier_with_matching_column.delete(value_index) unless intervals[classifier_index].matches?(value)
    end
  end
end

# Now eliminate!
eliminated = []
while classifiers_with_matching_columns.any? {|c| c.count > 1} do
  classifiers_with_matching_columns.each_with_index do |classifiers, index|
    if classifiers.count == 1
      # Now remove this one classifier from all other columns
      column = classifiers.first
      classifiers_with_matching_columns.each_with_index do |other_classifier, other_index|
        if index != other_index
          other_classifier.delete(column)
        end
      end
    end
  end
end

p classifiers_with_matching_columns

intervals.each_with_index do |interval, index|
  classifier_name = interval.name
  puts "#{interval.name}: Column #{classifiers_with_matching_columns[index].first}"
end

correct_columns = classifiers_with_matching_columns[0..5].map {|c| c.first}
puts "Correct columns: #{correct_columns}"

departure_values = classifiers_with_matching_columns[0..5].map {|c| my_ticket.split(',').map(&:to_i)[c.first]}
p departure_values

result = 1
departure_values.each {|v| result *= v}
p result