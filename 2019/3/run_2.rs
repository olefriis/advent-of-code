use std::fs::File;
use std::io::{self, BufRead};
use std::collections::{HashSet, HashMap};
use std::cmp::min;

#[derive(PartialEq, Eq, Hash, Clone)]
struct Position {
  x: i32,
  y: i32
}

fn parse_wire(wire_directions: &String) -> (HashSet<Position>, HashMap<Position, u32>) {
  let mut result_positions = HashSet::new();
  let mut result_distances = HashMap::new();

  let mut position = Position{ x: 0, y: 0 };
  let mut distance = 0;
  for direction in wire_directions.split(',') {
    let (dir, length) = direction.split_at(1);
    for _ in 0..length.parse::<u32>().unwrap() {
      match dir {
        "U" => { position.y += 1 },
        "D" => { position.y -= 1 },
        "R" => { position.x += 1 },
        "L" => { position.x -= 1 },
        _ => { panic!("Unknown direction {}", direction); }
      }
      result_positions.insert(position.clone());
      distance += 1;
      if !result_distances.contains_key(&position) {
        result_distances.insert(position.clone(), distance);
      }
    }
  }

  (result_positions, result_distances)
}

fn main() -> std::io::Result<()> {
  let file = File::open("input")?;
  let lines: Vec<String> = io::BufReader::new(file).lines().map(|line| line.unwrap()).collect();
  let mut lines_iter = lines.iter();

  let (wire1_positions, wire1_distances) = parse_wire(lines_iter.next().unwrap());
  let (wire2_positions, wire2_distances) = parse_wire(lines_iter.next().unwrap());

  let closest_overlap = wire1_positions.intersection(&wire2_positions).fold(None, |a, b| {
    let combined_distance_to_b = wire1_distances[b] + wire2_distances[b];
    match a {
      None => Some(combined_distance_to_b),
      Some(shortest_previous_distance) => Some(min(shortest_previous_distance, combined_distance_to_b))
    }
  });

  println!("Closest overlap is {}", closest_overlap.unwrap());
  Ok(())
}
