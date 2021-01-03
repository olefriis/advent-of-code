lines = File.readlines('input').map(&:to_i)

(0..(lines.count-3)).each do |line_1|
  first = lines[line_1]
  (line_1..(lines.count-2)).each do |line_2|
    second = lines[line_2]
    (line_2..(lines.count-2)).each do |line_3|
      third = lines[line_3]
    
      if first + second + third == 2020
        puts "#{first} + #{second} + #{third} = 2020"
        puts "#{first} * #{second} * #{third} = #{first * second * third}"
        exit
      end
    end
  end
end

puts 'Nothing found'
