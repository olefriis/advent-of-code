use std::fs::File;
use std::io::{self, BufRead};
use std::collections::{HashMap,HashSet};
use std::cmp;

fn main() -> std::io::Result<()> {
  let file = File::open("12/input")?;
  let lines: Vec<String> = io::BufReader::new(file).lines().map(|line| line.unwrap()).collect();
  let moons: Vec<Moon> = lines.iter().map(|line| parse_moon(line)).collect();

  println!("Got {} moons", moons.len());

  let rounds: Vec<u64> = (0..3).map(|axis| iterate_until_repeat(&moons, axis)).collect();
  println!("Rounds: {:?}", rounds); // [2028, 5898, 4702]

  let primes: Vec<Vec<u64>> = rounds.iter().map(|r| split_to_primes(r)).collect();
  println!("Primes: {:?}", primes);

  let combined_primes = combine_primes(&primes);
  println!("Combined primes: {}", combined_primes);

  Ok(())
}

struct Moon {
  position: Vec<i32>,
  velocity: Vec<i32>,
}

fn combine_primes(prime_list: &Vec<Vec<u64>>) -> u64 {
  let mut required_prime_counts = HashMap::new();

  for primes in prime_list.iter() {
    // Count how many of each prime we have
    let mut counts = HashMap::new();
    for prime in primes.iter() {
      let existing_count = match counts.get(prime) {
        None => 0,
        Some(&value) => value,
      };
      counts.insert(prime, existing_count + 1);
    }

    // Then ensure that we have at least the required amount of primes in the resulting list
    for (&prime, &required_count) in counts.iter() {
      let existing_count = match required_prime_counts.get(prime) {
        None => 0,
        Some(&value) => value,
      };
      required_prime_counts.insert(*prime, cmp::max(existing_count, required_count));
    }
  }

  let mut result = 1;
  for (&prime, &required_count) in required_prime_counts.iter() {
    for _ in 0..required_count {
      result *= prime;
    }
  }

  result
}

fn split_to_primes(number: &u64) -> Vec<u64> {
  let mut working_number = number.clone();
  let mut current_divisor = 2;
  let mut primes = vec![];

  while current_divisor <= working_number {
    if working_number % current_divisor == 0 {
      primes.push(current_divisor);
      working_number /= current_divisor;
    } else {
      current_divisor += 1;
    }
  }

  primes
}

fn iterate_until_repeat(moons: &Vec<Moon>, axis: usize) -> u64 {
  let mut positions: Vec<i32> = moons.iter().map(|moon| moon.position[axis]).collect();
  let mut velocities: Vec<i32> = moons.iter().map(|moon| moon.velocity[axis]).collect();
  let mut previous_states = HashSet::new();

  let mut result = 0;
  loop {
    let moon_states: Vec<String> = positions.iter().chain(velocities.iter()).map(|component| component.to_string()).collect();
    let state = moon_states.join(",");
    if previous_states.contains(&state) {
      break
    }
    previous_states.insert(state);

    update_velocities(&mut velocities, &positions);
    update_positions(&velocities, &mut positions);

    result += 1;
  }

  result
}

fn update_velocities(velocities: &mut Vec<i32>, positions: &Vec<i32>) {
  for moon_number in 0..velocities.len() {
    let position = positions[moon_number];

    for other_moon_number in 0..velocities.len() {
      if moon_number != other_moon_number {
        let other_position = positions[other_moon_number];

        if position < other_position {
          velocities[moon_number] += 1;
        } else if position > other_position {
          velocities[moon_number] -= 1;
        }
      }
    }
  }
}

fn update_positions(velocities: &Vec<i32>, positions: &mut Vec<i32>) {
  for moon_number in 0..velocities.len() {
    positions[moon_number] += velocities[moon_number];
  }
}

fn parse_moon(line: &str) -> Moon {
  let components = line.strip_prefix("<").unwrap().strip_suffix(">").unwrap().split(", ");
  let position = components.map(|component| parse_number(component)).collect();
  Moon {
    position: position,
    velocity: vec![0, 0, 0],
  }
}

fn parse_number(s: &str) -> i32 {
  let mut components = s.split("=");
  components.next();
  components.next().unwrap().parse().unwrap()
}
