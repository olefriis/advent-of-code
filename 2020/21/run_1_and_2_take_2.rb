allergens_to_possible_ingredients = {}
all_ingredients = []
File.readlines('input').map(&:strip).each do |line|
  raise "Weird line: #{line}" unless line =~ /^(.*) \(contains (.*)\)$/
  ingredients, allergens = $1.split(' '), $2.split(', ')

  allergens.each do |allergen|
    allergens_to_possible_ingredients[allergen] ||= ingredients
    allergens_to_possible_ingredients[allergen] &= ingredients
  end
  all_ingredients += ingredients
end

determined_allergens = {}
begin
  previously_determined_allergens = determined_allergens.count

  allergens_to_possible_ingredients.each do |allergen, possible_ingredients|
    possible_ingredients -= (determined_allergens.keys - [allergen]).map {|allergen| determined_allergens[allergen]}
    determined_allergens[allergen] = possible_ingredients.first if possible_ingredients.count == 1
  end
end until determined_allergens.count == previously_determined_allergens

# Part 1
puts "Listed #{(all_ingredients - determined_allergens.values).count} times"

# Part 2
puts determined_allergens.keys.sort.map {|allergen| determined_allergens[allergen]}.join(',')
