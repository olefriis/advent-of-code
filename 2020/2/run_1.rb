def valid?(line)
  raise "Weird line: #{line}" unless line =~ /^(\d+)-(\d+) ([a-z])\: (.*)$/
  minimum, maximum, letter, password = $1.to_i, $2.to_i, $3, $4

  only_required_letters_from_password = password.gsub(/[^#{letter}]/, '')

  only_required_letters_from_password.length >= minimum && only_required_letters_from_password.length <= maximum
end

lines = File.readlines('input')

valid_lines = lines.select { |line| valid?(line) }

puts "#{valid_lines.count} valid passwords"
