mod intcode;
use intcode::{Intcode, read_program};
use std::collections::HashMap;

type ShortestPaths = HashMap<Position, Position>;

#[derive(PartialEq, Eq, Hash, Clone, Debug)]
struct Position {
  x: i64,
  y: i64,
}

enum Direction {
  North,
  South,
  West,
  East,
}

fn main() -> std::io::Result<()> {
  let program: Vec<i64> = read_program("15/input");

  let mut shortest_paths = ShortestPaths::new();

  // We start at 0,0
  let mut current_border = vec![Position { x: 0, y: 0}];
  shortest_paths.insert(Position { x: 0, y: 0}, Position { x: 0, y: 0 });

  let mut current_distance = 0;

  loop {
    current_distance += 1;
    let mut upcoming_border = vec![];
    if current_distance % 1000 == 0 {
      println!("Current distance: {}", current_distance);
    }

    for position in current_border.iter() {
      for (nearby_position, tile_type) in examine_nearby_tiles(&position, &shortest_paths, &program).iter() {
        if !shortest_paths.contains_key(&nearby_position) {
          if *tile_type != 0 {
            shortest_paths.insert(nearby_position.clone(), position.clone());
            upcoming_border.push(nearby_position.clone());
          }
          if *tile_type == 2 {
            let path = construct_path_to(nearby_position, &shortest_paths);
            // We found it!
            println!("Found it - path is {} steps long", path.len());
            return Ok(());
          }
        }
      }
    }

    current_border = upcoming_border;
  }
}

impl Direction {
  fn opposite(&self) -> Direction {
    match self {
      Direction::North => Direction::South,
      Direction::South => Direction::North,
      Direction::West => Direction::East,
      Direction::East => Direction::West,
    }
  }

  fn from(i: i64) -> Direction {
    match i {
      1 => Direction::North,
      2 => Direction::South,
      3 => Direction::West,
      4 => Direction::East,
      _ => panic!("Unknown direction: {}", i)
    }
  }

  fn to_i(&self) -> i64 {
    match self {
      Direction::North => 1,
      Direction::South => 2,
      Direction::West => 3,
      Direction::East => 4,
    }
  }
}

fn examine_nearby_tiles(position: &Position, shortest_paths: &ShortestPaths, program: &Vec<i64>) -> Vec<(Position, i64)> {
  let mut intcode = Intcode::new(program);
  move_to(position, &mut intcode, shortest_paths);

  let mut nearby_tiles = vec![];
  for direction_i in 1..=4 {
    let direction = Direction::from(direction_i);
    let input = vec![direction_i];
    let position_in_direction = direction_from(position, &direction);
    let tile_at_direction = intcode.run(&input).unwrap();
    nearby_tiles.push((position_in_direction, tile_at_direction));
    if tile_at_direction != 0 {
      // Move back
      let input = vec![direction.opposite().to_i()];
      intcode.run(&input).unwrap();
    }
  }

  nearby_tiles
}

fn direction_from(position: &Position, direction:& Direction) -> Position {
  match *direction {
    Direction::North => Position { y: position.y + 1, ..*position },
    Direction::South => Position { y: position.y - 1, ..*position },
    Direction::West => Position { x: position.x - 1, ..*position },
    Direction::East => Position { x: position.x + 1, ..*position },
  }
}

fn move_to(destination: &Position, intcode: &mut Intcode, shortest_paths: &ShortestPaths) {
  let mut current_position = Position { x: 0, y: 0 };
  let path = construct_path_to(destination, shortest_paths);
  for next_position in path.iter() {
    let direction = if next_position.x > current_position.x {
      Direction::East
    } else if next_position.x < current_position.x {
      Direction::West
    } else if next_position.y > current_position.y {
      Direction::North
    } else if next_position.y < current_position.y {
      Direction::South
    } else {
      panic!("No idea how to move from {:?} to {:?}", current_position, next_position);
    };
    let input = vec![direction.to_i()];
    match intcode.run(&input) {
      Some(1) => {}, // All good
      something => panic!("Unexpected output when moving from {:?} to {:?}: {:?}. Path: {:?}", current_position, next_position, something, path),
    };
    current_position = next_position.clone();
  }
}

// Recursive. I think we'll survive.
fn construct_path_to(position: &Position, shortest_paths: &ShortestPaths) -> Vec<Position> {
  if position.x == 0 && position.y == 0 {
    // We're already here!
    return vec![];
  }

  let predecessor = shortest_paths.get(position).unwrap();
  let mut path_to_predecessor = construct_path_to(predecessor, shortest_paths);
  path_to_predecessor.push(position.clone());
  path_to_predecessor
}
