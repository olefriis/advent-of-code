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

  let mut number_of_orbits = 0;
  for key in orbits.keys() {
    number_of_orbits += 1;
    let mut next_key = &orbits[key];
    while next_key != "COM" {
      number_of_orbits += 1;
      next_key = &orbits[next_key];
    }
  }

  println!("Number of direct and indirect orbits: {}", number_of_orbits);

  Ok(())
}