chars = File.read('06/input').chars

def solve(chars, marker_length)
  (0..chars.count-marker_length).each do |i|
    if chars[i...i+marker_length].uniq.count == marker_length
      return i+marker_length
    end
  end
end

puts "Part 1: #{solve(chars, 4)}"
puts "Part 1: #{solve(chars, 14)}"
