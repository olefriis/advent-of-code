positions = File.read('input').split(',').map(&:to_i)
min, max = positions.minmax
puts min.upto(max).map {|p1| positions.map {|p2| (p1 - p2).abs}.sum}.min
