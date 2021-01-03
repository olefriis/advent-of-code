puts (32..848).to_a - File.readlines('input').map { |line| line.strip.tr('BFRL', '1010').to_i(2) }
