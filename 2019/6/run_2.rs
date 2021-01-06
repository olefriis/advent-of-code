use std::fs::File;
use std::io::{self, BufRead};
use std::collections::HashMap;

fn main() -> std::io::Result<()> {
  let file = File::open("6/input")?;

  let mut orbits = HashMap::<String, String>::new();
  io::BufReader::new(file).lines().for_each(|line| {
    let unwrapped_line = line.unwrap();
    let mut parts = unwrapped_line.split(')');
    let first = parts.next().unwrap().to_string();
    let next = parts.next().unwrap().to_string();
    orbits.insert(next, first);
  });

  // First, mark how many orbital transfers it takes SAN to go towards COM
  let mut distances_for_san = HashMap::<String, u32>::new();
  let mut next_key_from_san = &orbits["SAN"];
  let mut current_distance_for_san = 0;
  while next_key_from_san != "COM" {
    distances_for_san.insert(next_key_from_san.clone(), current_distance_for_san);
    current_distance_for_san += 1;
    next_key_from_san = &orbits[next_key_from_san];
  }

  // Then just go from YOU towards COM until we hit SAN on the way
  let mut next_key_from_you = &orbits["YOU"];
  let mut current_distance_for_you = 0;
  while !distances_for_san.contains_key(next_key_from_you) {
    current_distance_for_you += 1;
    next_key_from_you = &orbits[next_key_from_you];
  }

  let total_distance = current_distance_for_you + distances_for_san[next_key_from_you];

  println!("Orbital distance from YOU to SAN: {}", total_distance);

  Ok(())
}