use std::fs::File;
use std::io::{self, BufRead};
use std::collections::HashSet;
use std::cmp::min;

#[derive(PartialEq, Eq, Hash, Clone)]
struct Position {
  x: i32,
  y: i32
}

fn parse_wire(wire_directions: &String) -> HashSet<Position> {
  let mut result = HashSet::new();

  let mut position = Position{ x: 0, y: 0 };
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
      result.insert(position.clone());
    }
  }

  result
}

fn main() -> std::io::Result<()> {
  let file = File::open("input")?;
  let lines: Vec<String> = io::BufReader::new(file).lines().map(|line| line.unwrap()).collect();
  let mut lines_iter = lines.iter();

  let wire1 = parse_wire(lines_iter.next().unwrap());
  let wire2 = parse_wire(lines_iter.next().unwrap());

  let closest_overlap = wire1.intersection(&wire2).fold(None, |a, b| {
    let manhattan_distance_to_b = b.x.abs() + b.y.abs();
    match a {
      None => Some(manhattan_distance_to_b),
      Some(shortest_previous_manhattan_distance) => Some(min(shortest_previous_manhattan_distance, manhattan_distance_to_b))
    }
  });

  println!("Closest overlap is {}", closest_overlap.unwrap());
  Ok(())
}
