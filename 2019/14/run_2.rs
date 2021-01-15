use std::fs::File;
use std::io::{self, BufRead};
use std::collections::{HashMap, HashSet};

/*
 * Basically the same as part 1, just using f64 instead of u32...
 */
fn main() -> std::io::Result<()> {
  let file = File::open("14/input")?;
  let lines: Vec<String> = io::BufReader::new(file).lines().map(|line| line.unwrap()).collect();
  let mut reactions: HashSet<Reaction> = lines.iter().map(|line| parse_reaction(line)).collect();

  println!("{} reactions", reactions.len());

  let reaction_to_fuel = take_reaction_from_set(&mut reactions, "FUEL");
  let mut required_input = HashMap::new();
  for input in reaction_to_fuel.inputs {
    required_input.insert(input.chemical, input.quantity as f64);
  }

  while reactions.len() > 0 {
    println!("Required chemicals: {:?}", required_input);

    // Find any reaction whose output is not used as input anywhere
    let all_input_chemicals: Vec<&String> = reactions.iter().flat_map(|reaction| reaction.inputs.iter().map(|input| &input.chemical)).collect();
    let reaction_not_used_as_input = reactions.iter().filter(|reaction| !all_input_chemicals.contains(&&reaction.output.chemical)).next().unwrap();
    let output_from_reaction_not_used_as_input = reaction_not_used_as_input.output.chemical.clone();
    let reaction = take_reaction_from_set(&mut reactions, output_from_reaction_not_used_as_input.as_str());

    let required_quantity = match required_input.remove(&reaction.output.chemical) {
      None => 0_f64,
      Some(quantity) => quantity,
    };
    let required_reactions = required_quantity as f64 / reaction.output.quantity as f64;
    println!("{} of {} produces {}.", required_reactions, reaction.output.chemical, required_quantity);
    for input in reaction.inputs {
      let existing_quantities = match required_input.get(&input.chemical) {
        None => 0_f64,
        Some(&quantity) => quantity,
      };
      required_input.insert(input.chemical, existing_quantities + required_reactions * input.quantity as f64);
    }

    reactions = reactions.into_iter().filter(|reaction| reaction.output.chemical == reaction.output.chemical).collect();
  }
  println!("Required chemicals: {:?}", required_input);

  let required_ore_per_fuel = required_input.iter().next().unwrap().1;
  let generated_fuel = 1000000000000_f64 / required_ore_per_fuel;
  println!("We can generate {} FUEL", generated_fuel as u64);

  Ok(())
}

fn take_reaction_from_set(reactions: &mut HashSet<Reaction>, output_chemical: &str) -> Reaction {
  // I wish I could just give a predicate to HashSet, and HashSet would remove the matching elements and return them!
  let reaction_clone = reactions.iter().find(|reaction| reaction.output.chemical.as_str() == output_chemical).unwrap().clone();
  reactions.take(&reaction_clone).unwrap()
}

#[derive(Eq, PartialEq, Hash, Clone)]
struct QuantityAndChemical {
  quantity: u32,
  chemical: String,
}

#[derive(Eq, PartialEq, Hash, Clone)]
struct Reaction {
  inputs: Vec<QuantityAndChemical>,
  output: QuantityAndChemical,
}

fn parse_reaction(line: &str) -> Reaction {
  let mut parts = line.split(" => ");
  let all_inputs_str = parts.next().unwrap();
  let output_str = parts.next().unwrap();

  Reaction {
    inputs: parse_quantities_and_chemicals(all_inputs_str),
    output: parse_quantity_and_chemical(output_str),
  }
}

fn parse_quantities_and_chemicals(s: &str) -> Vec<QuantityAndChemical> {
  s.split(", ").map(parse_quantity_and_chemical).collect()
}

fn parse_quantity_and_chemical(s: &str) -> QuantityAndChemical {
  let mut parts = s.split(" ");
  let quantity: u32 = parts.next().unwrap().parse().unwrap();
  let chemical = parts.next().unwrap();

  QuantityAndChemical {
    quantity: quantity,
    chemical: chemical.to_string(),
  }
}