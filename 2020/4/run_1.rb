require 'set'

lines = File.readlines('input').map(&:strip)
# Extra blank line to trigger parsing of the last passport
lines << ''

valid_passports = 0
required_fields = Set.new(['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid'])

fields_in_current_passport = Set.new
lines.each do |line|
  if line.empty?
    valid_passports += 1 if fields_in_current_passport & required_fields == required_fields
    fields_in_current_passport = Set.new
  else
    fields = line.split(/ +/)
    fields.each do |field|
      throw "Weird line: #{line}" unless field =~ /(.*):.*/
      fields_in_current_passport << $1
    end
  end
end

puts "We have #{valid_passports} valid passports"