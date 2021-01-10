use std::fs::File;
use std::io::{self, BufRead};
use std::collections::HashSet;

#[derive(PartialEq, Clone)]
enum Cell {
  Asteroid,
  Empty,
  Examined,
}

#[derive(PartialEq, Eq, Hash, Clone)]
struct Position {
  x: usize,
  y: usize,
}

fn check_and_mark(map: &mut Vec<Vec<Cell>>, origin: &Position, direction_x: i32, direction_y: i32) -> Option<Position> {
  let mut found_asteroid = None;

  let mut position_x = origin.x as i32 + direction_x;
  let mut position_y = origin.y as i32 + direction_y;
  while position_y >= 0 && position_y < map.len() as i32 && position_x >= 0 && position_x < map[position_y as usize].len() as i32 {
    if map[position_y as usize][position_x as usize] == Cell::Asteroid {
      found_asteroid = Some(Position { x: position_x as usize, y: position_y as usize });
    }
    map[position_y as usize][position_x as usize] = Cell::Examined;

    position_x += direction_x;
    position_y += direction_y;
  }

  found_asteroid
}

fn visible_asteroids(original_map: &Vec<Vec<Cell>>, position: &Position) -> HashSet<Position> {
  if original_map[position.y][position.x] == Cell::Empty {
    return HashSet::new();
  }

  let mut map = original_map.clone();
  let mut result = HashSet::new();

  // Check above
  // I miss ranges going reverse - would love to do
  // for to_y in (y-1)..=0 {
  for offset_y in 0..position.y {
    let to_y = position.y - 1 - offset_y;
    for to_x in 0..(map[to_y as usize].len() as i32) {
      match check_and_mark(&mut map, &position, to_x - position.x as i32, to_y as i32 - position.y as i32) {
        Some(position) => { result.insert(position); },
        None => (),
      }
    }
  }

  // Check to the left
  match check_and_mark(&mut map, &position, -1, 0) {
    Some(position) => { result.insert(position); },
    None => (),
  }

  // Check to the right
  match check_and_mark(&mut map, &position, 1, 0) {
    Some(position) => { result.insert(position); },
    None => (),
  }

  // Check below
  for to_y in (position.y+1)..map.len() {
    for to_x in 0..(map[to_y as usize].len() as i32) {
      match check_and_mark(&mut map, &position, to_x - position.x as i32, to_y as i32 - position.y as i32) {
        Some(position) => { result.insert(position); },
        None => (),
      }
    }
  }

  result
}

fn main() -> std::io::Result<()> {
  let file = File::open("10/input")?;
  let lines_iter = io::BufReader::new(file).lines().map(|line| line.unwrap());
  let map: Vec<Vec<Cell>> = lines_iter.map(|line| {
    line.chars().map(|char| {
      match char {
        '#' => Cell::Asteroid,
        _ => Cell::Empty,
      }
    }).collect()
  }).collect();

  let positions = (0..map.len()).flat_map(|y| (0..map[y].len()).map(move |x| Position { x: x, y: y }));
  let best_position = positions.max_by_key(|position| visible_asteroids(&map, position).len()).unwrap();
  let visible_from_best_position = visible_asteroids(&map, &best_position);

  println!("{},{} can see {} asteroids", best_position.x, best_position.y, visible_from_best_position.len());

  Ok(())
}
