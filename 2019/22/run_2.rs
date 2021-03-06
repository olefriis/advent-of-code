use std::fs::File;
use std::io::{self, BufRead};

#[derive(Clone, Debug, Copy)]
enum Technique {
  DealIntoNewStack,
  Cut,
  DealWithIncrement,
}

#[derive(Clone, Debug, Copy)]
struct Command {
  technique: Technique,
  argument: u128,
}

fn main() -> std::io::Result<()> {
  let deck_size: u128 = 119315717514047;
  let iterations: u128 = 101741582076661;

  let file = File::open("22/input")?;
  let commands: Vec<Command> = io::BufReader::new(file).lines().map(|line| line.unwrap()).map(|line| {
    if line.starts_with("deal into new stack") {
      Command { technique: Technique::DealIntoNewStack, argument: 0 }
    } else if line.starts_with("cut ") {
      let cut_at: u128 = (line[4..].parse::<i64>().unwrap() + deck_size as i64) as u128 % deck_size;
      Command { technique: Technique::Cut, argument: cut_at }
    } else if line.starts_with("deal with increment ") {
      let increment: u128 = line[20..].parse().unwrap();
      Command { technique: Technique::DealWithIncrement, argument: increment }
    } else {
      panic!("Unknown command: '{}'", line)
    }
  }).collect();

  let reduced_commands = reduce(&commands, deck_size);
  println!("Reduced commands:");
  print_commands(&reduced_commands);

  let mut next_commands = reduced_commands.clone();
  let mut resulting_commands = vec![];
  let mut remaining_iterations = iterations;
  while remaining_iterations > 0 {
    if remaining_iterations % 2 == 1 {
      let mut commands_to_append = next_commands.clone();
      resulting_commands.append(&mut commands_to_append);
      resulting_commands = reduce(&resulting_commands, deck_size);
    }

    remaining_iterations /= 2;
    next_commands.append(&mut next_commands.clone());
    next_commands = reduce(&next_commands, deck_size);
  }

  println!("OK! Resulting commands:");
  print_commands(&resulting_commands);

  let final_result = execute(&resulting_commands, deck_size);
  println!("Final result: {}", final_result);

  Ok(())
}

fn execute(commands: &Vec<Command>, deck_size: u128) -> u128 {
  let mut position = 2020;
  let mut reversed_commands = commands.clone();
  reversed_commands.reverse();
  for command in reversed_commands.iter() {
    match command.technique {
      Technique::Cut => {
        position = (deck_size + position + command.argument) % deck_size;
      },
      Technique::DealIntoNewStack => {
        position = deck_size - position - 1;
      },
      Technique::DealWithIncrement => {
        let primes_for_increments = split_into_primes(command.argument);
      
        for prime in primes_for_increments {
          let reverse_increment = find_reverse_increment(prime, deck_size);
          position = (position * reverse_increment) % deck_size;
        }
      }
    }
  }

  let result = position;

  // Check that we can go forward again
  for command in commands.iter() {
    match command.technique {
      Technique::Cut => {
        position = (deck_size + position - command.argument) % deck_size;
      },
      Technique::DealIntoNewStack => {
        position = deck_size - position - 1;
      },
      Technique::DealWithIncrement => {
        position = (position * command.argument) % deck_size;
      },
    };
  }
  if position != 2020 {
    panic!("We did not get back to 2020, but {}", position);
  }

  result
}

fn find_reverse_increment(original_increment: u128, deck_size: u128) -> u128 {
  let groups = deck_size / original_increment;
  let mut new_position: u128 = 0;
  let mut original_position = 0;
  loop {
    new_position = (new_position + groups * original_increment + original_increment) % deck_size;
    original_position += groups + 1;
    if new_position >= original_increment {
      new_position -= original_increment;
      original_position -= 1;
    }
    if new_position >= original_increment {
      println!("Something odd... {}", new_position);
    }
    if new_position == 1 {
      return original_position
    }
  }
}

// Very ineffective, but also very straightforward
fn split_into_primes(number: u128) -> Vec<u128> {
  let mut n = number;
  let mut result = vec![];
  let mut current_try = 2;
  while n > 1 {
    if n % current_try == 0 {
      result.push(current_try);
      n /= current_try;
    } else {
      current_try += 1;
    }
  }
  result
}

fn reduce(commands: &Vec<Command>, deck_size: u128) -> Vec<Command> {
  let mut result = commands.clone();

  let mut run_again = true;
  while run_again {
    run_again = false;
    for i in 0..result.len()-1 {
      let first_command = &result[i];
      let second_command = &result[i+1];
      match (&first_command.technique, &second_command.technique) {
        (Technique::Cut, Technique::DealIntoNewStack) => {
          let old_cut = first_command.argument;
          result[i] = Command { technique: Technique::DealIntoNewStack, argument: 0 };
          result[i+1] = Command { technique: Technique::Cut, argument: deck_size - old_cut };
          run_again = true;
        },
        (Technique::Cut, Technique::DealWithIncrement) => {
          let new_increment = second_command.argument;
          let new_cut = (first_command.argument * second_command.argument) % deck_size;
          result[i] = Command { technique: Technique::DealWithIncrement, argument: new_increment };
          result[i+1] = Command { technique: Technique::Cut, argument: new_cut };
          run_again = true;
        },
        (Technique::DealIntoNewStack, Technique::DealWithIncrement) => {
          let position_of_last_element = deck_size - 1 - ((deck_size-1) * second_command.argument) % deck_size;
          let new_cut = position_of_last_element;
          let new_increment = second_command.argument;
          result[i] = Command { technique: Technique::DealWithIncrement, argument: new_increment };
          result[i+1] = Command { technique: Technique::DealIntoNewStack, argument: 0 };
          result.insert(i+2, Command { technique: Technique::Cut, argument: new_cut });
          run_again = true;
        },
        (Technique::Cut, Technique::Cut) => {
          let new_cut = (first_command.argument + second_command.argument) % deck_size;
          result.remove(i);
          result[i] = Command { technique: Technique::Cut, argument: new_cut };
          run_again = true;
        },
        (Technique::DealIntoNewStack, Technique::DealIntoNewStack) => {
          result.remove(i);
          result.remove(i);
          run_again = true;
        },
        (Technique::DealWithIncrement, Technique::DealWithIncrement) => {
          let new_increment = (first_command.argument * second_command.argument) % deck_size;
          result.remove(i);
          result[i] = Command { technique: Technique::DealWithIncrement, argument: new_increment };
          run_again = true;
        },
        _ => () /* Ignore */,
      };

      if run_again {
        break;
      }
    }
  }

  result
}

fn print_commands(commands: &Vec<Command>) {
  for command in commands.iter() {
    match command.technique {
      Technique::DealIntoNewStack => println!("deal into new stack"),
      Technique::Cut => println!("cut {}", command.argument),
      Technique::DealWithIncrement => println!("deal with increment {}", command.argument),
    };
  }
}
