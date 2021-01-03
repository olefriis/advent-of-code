require 'set'

lines = File.readlines('input').map(&:strip)
# Extra blank line to trigger parsing of the last passport
lines << ''

validations = {
  'byr' => ->(i) { i =~ /^\d{4}$/ && i.to_i >= 1920 && i.to_i <= 2002 },
  'iyr' => ->(i) { i =~ /^\d{4}$/ && i.to_i >= 2010 && i.to_i <= 2020 },
  'eyr' => ->(i) { i =~ /^\d{4}$/ && i.to_i >= 2020 && i.to_i <= 2030 },
  'hgt' => ->(i) {
    if i =~ /^(\d+)cm$/
      $1.to_i >= 150 && $1.to_i <= 193
    elsif i =~ /^(\d+)in$/
      $1.to_i >= 59 && $1.to_i <= 76
    end
  },
  'hcl' => ->(i) { i =~ /^#[0-9a-f]{6}$/ },
  'ecl' => ->(i) { ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'].include?(i) },
  'pid' => ->(i) { i=~ /^[0-9]{9}$/ },
  'cid' => ->(i) { true }
}

valid_passports = 0
required_fields = Set.new(validations.keys - ['cid'])

fields_in_current_passport = Set.new
lines.each do |line|
  if line.empty?
    valid_passports += 1 if fields_in_current_passport & required_fields == required_fields
    fields_in_current_passport = Set.new
  else
    fields = line.split(/ +/)
    fields.each do |field|
      throw "Weird line: #{line}" unless field =~ /(.*):(.*)/
      key, value = $1, $2
      throw "No validation for '#{key}" unless validation = validations[key]
      result = validations[key].call(value)
      fields_in_current_passport << key if validations[key].call(value)
    end
  end
end

puts "We have #{valid_passports} valid passports"