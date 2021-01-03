puts File.readlines('input').map { |line| line.strip.tr('BFRL', '1010').to_i(2) }.max
