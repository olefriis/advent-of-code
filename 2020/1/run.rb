lines = File.readlines('input').map(&:to_i)

(0..(lines.count-2)).each do |line_1|
  first = lines[line_1]
  (line_1..(lines.count-1)).each do |line_2|
    second = lines[line_2]

    if first + second == 2020
      puts "#{first} + #{second} = 2020"
      puts "#{first} * #{second} = #{first * second}"
      exit
    end
  end
end

puts 'Nothing found'
