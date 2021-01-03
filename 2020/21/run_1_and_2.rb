require 'pry'
lines = File.readlines('input').map(&:strip)

ingredients_to_allergens = {}
allergens_to_ingredients = {}
lists_with_allergen = {}
ingredients_listed = []
lines.each do |line|
  raise "Weird line: #{line}" unless line =~ /^(.*) \(contains (.*)\)$/
  ingredients, allergens = $1.split(' '), $2.split(', ')

  ingredients.each do |ingredient|
    ingredients_listed << ingredient

    ingredients_to_allergens[ingredient] ||= allergens
    ingredients_to_allergens[ingredient] |= allergens
  end

  allergens.each do |allergen|
    allergens_to_ingredients[allergen] ||= ingredients
    allergens_to_ingredients[allergen] |= ingredients

    lists_with_allergen[allergen] ||= []
    lists_with_allergen[allergen] << ingredients
  end
end

allergen_to_ingredient = {}
while allergen_to_ingredient.count < allergens_to_ingredients.count
  # Find all allergens corresponding to its one known ingredient
  lists_with_allergen.each do |allergen, lists|
    possible_ingredients = lists.inject(lists.first, &:&)
    if possible_ingredients.count == 1
      allergen_to_ingredient[allergen] = possible_ingredients.first
    end
  end

  # Go through each allergen, remove ingredients known to have OTHER allergens from their potential lists
  lists_with_allergen.keys.each do |allergen|
    known_ingredient = allergen_to_ingredient[allergen]
    if known_ingredient
      lists_with_allergen.delete(allergen)
      lists_with_allergen.keys.each do |allergen|
        lists = lists_with_allergen[allergen]
        lists.each do |list|
          list.delete(known_ingredient)
        end
      end
    end
  end
end

p allergen_to_ingredient

known_ingredients_with_allergens = allergen_to_ingredient.values
all_ingredients = ingredients_to_allergens.keys
ingredients_with_no_allergens = all_ingredients - known_ingredients_with_allergens

puts "No allergens: #{ingredients_with_no_allergens}"

counts = 0
ingredients_with_no_allergens.each do |ingredient|
  counts += ingredients_listed.count(ingredient)
end

puts "Listed #{counts} times"

ingredients_sorted_by_allergens = allergen_to_ingredient.keys.sort.map {|allergen| allergen_to_ingredient[allergen]}.join(',')

puts ingredients_sorted_by_allergens
