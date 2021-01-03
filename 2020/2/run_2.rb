def valid?(line)
  raise "Weird line: #{line}" unless line =~ /^(\d+)-(\d+) ([a-z])\: (.*)$/
  first, last, letter, password = $1.to_i, $2.to_i, $3, $4

  (password[first-1] == letter) != password[last-1] == letter
end

lines = File.readlines('input')

valid_lines = lines.select { |line| valid?(line) }

puts "#{valid_lines.count} valid passwords"
