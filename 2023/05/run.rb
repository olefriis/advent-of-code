lines = File.readlines('05/input').map(&:strip)

Rule = Struct.new(:source, :destination, :range) do
  def covers?(n)
    n >= source && n <= source + range
  end

  def map(n)
    n + destination - source
  end

  def mapped_range(range_start, range_amount)
    inside_range = split_range(range_start, range_amount)[:inside]
    if inside_range
      [map(inside_range.first), inside_range.last]
    else
      nil
    end
  end

  def unmapped_ranges(range_start, range_amount)
    split_range(range_start, range_amount)[:outside]
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

    outside = []
    outside << [before_start, before_end - before_start] if before_start < before_end
    outside << [after_start, after_end - after_start] if after_start < after_end

    {
      inside: inside_start < inside_end ? [inside_start, inside_end - inside_start] : nil,
      outside:
    }
  end
end

from = to = rules = nil
rule_groups = []
lines[1..-1].each do |line|
  if line == ''
    from = to = nil
  elsif from == nil
    line =~ /(.*)-to-(.*) map/ or raise "Bad header line: #{line}"
    from, to = $1, $2
    rules = []
    rule_groups << rules
  else
    line =~ /(\d+) (\d+) (\d+)/ or raise "Bad rule line: #{line}"
    destination, source, range = $1.to_i, $2.to_i, $3.to_i
    rules << Rule.new(source, destination, range)
  end
end

things = lines[0].scan(/\d+/).map(&:to_i)
rule_groups.each do |rules|
  things = things.map do |thing|
    matching_rule = rules.find { |rule| rule.covers?(thing) }
    matching_rule ? matching_rule.map(thing) : thing
  end
end
puts "Part 1: #{things.min}"

ranges = lines[0].scan(/\d+/).map(&:to_i).each_slice(2).to_a
rule_groups.each do |rules|
  mapped_ranges = []

  rules.each do |rule|
    new_ranges = []
    ranges.each do |range_start, range_amount|
      mapped_range = rule.mapped_range(range_start, range_amount)
      mapped_ranges << mapped_range if mapped_range
      rule.unmapped_ranges(range_start, range_amount).each {|range| new_ranges << range}
    end
    ranges = new_ranges
  end
  # The unmapped ranges are just mapped directly
  ranges.each { |range| mapped_ranges << range }

  ranges = mapped_ranges
end
puts "Part 2: #{ranges.map(&:first).min}"
