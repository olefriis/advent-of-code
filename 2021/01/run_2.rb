lines = File.readlines('input').map(&:to_i)
windows = lines.each_cons(3).map(&:sum)
puts windows.each_cons(2).count { |a, b| a < b }
