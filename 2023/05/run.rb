require 'pry'
lines = File.readlines('05/input').map(&:strip)

Rule = Struct.new(:source, :destination, :range) do
  def covers?(n)
    n >= source && n <= source + range
  end

  def map(n)
    n + destination - source
  end

  def mapped_range(range_start, range_amount)
    ranges = split_range(range_start, range_amount)
    if ranges[:inside]
      [ranges[:inside][0] + destination - source, ranges[:inside][1]]
    else
      nil
    end
  end

  def unmapped_ranges(range_start, range_amount)
    ranges = split_range(range_start, range_amount)
    result = []
    result << ranges[:before] if ranges[:before]
    result << ranges[:after] if ranges[:after]
    result
  end

  def split_range(range_start, range_amount)
    rule_start = source
    rule_end = source + range
    range_end = range_start + range_amount

    before_start = [range_start, rule_start].min
    before_end = [range_end, rule_start].min

    inside_start = [range_start, rule_start].max
    inside_end = [range_end, rule_end].min

    after_start = [range_start, rule_end].max
    after_end = [range_end, rule_end].max

    {
      before: before_start < before_end ? [before_start, before_end - before_start] : nil,
      inside: inside_start < inside_end ? [inside_start, inside_end - inside_start] : nil,
      after: after_start < after_end ? [after_start, after_end - after_start] : nil,
    }
  end
end

# from, to, rules
conversions = []

from = to = rules = nil
lines[1..-1].each do |line|
  if line == ''
    conversions << [from, to, rules] if from
    rules = []
    from = to = nil
  elsif from == nil
    line =~ /(.*)-to-(.*) map/ or raise "Bad header line: #{line}"
    from, to = $1, $2
  else
    line =~ /(\d+) (\d+) (\d+)/ or raise "Bad rule line: #{line}"
    destination, source, range = $1.to_i, $2.to_i, $3.to_i
    rules << Rule.new(source, destination, range)
  end
end
conversions << [from, to, rules] if from

things = lines[0].scan(/\d+/).map(&:to_i)
conversions.each do |from, to, rules|
  things = things.map do |thing|
    matching_rule = rules.find { |rule| rule.covers?(thing) }
    matching_rule ? matching_rule.map(thing) : thing
  end
  #puts "#{to}: #{things}"
end
puts "Part 1: #{things.min}"

ranges = lines[0].scan(/\d+/).map(&:to_i).each_slice(2).to_a
conversions.each do |from, to, rules|
  mapped_ranges = []

  rules.each do |rule|
    new_ranges = []
    ranges.dup.each do |range_start, range_amount|
      mapped_range = rule.mapped_range(range_start, range_amount)
      mapped_ranges << mapped_range if mapped_range
      rule.unmapped_ranges(range_start, range_amount).each {|range| new_ranges << range}
    end
    ranges = new_ranges
  end
  # The unmapped ranges are just mapped directly
  ranges.each { |range| mapped_ranges << range }

  ranges = mapped_ranges.uniq.sort_by(&:first)
end
puts "Part 2: #{ranges.map(&:first).min}"
