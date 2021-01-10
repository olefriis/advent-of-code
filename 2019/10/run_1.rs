use std::fs::File;
use std::io::{self, BufRead};

#[derive(PartialEq, Clone)]
enum Cell {
  Asteroid,
  Empty,
  Examined,
}

fn check_and_mark(mut map: Vec<Vec<Cell>>, origin_x: usize, origin_y: usize, direction_x: i32, direction_y: i32) -> (bool, Vec<Vec<Cell>>) {
  let mut found_asteroid = false;

  let mut position_x = origin_x as i32 + direction_x;
  let mut position_y = origin_y as i32 + direction_y;
  while position_y >= 0 && position_y < map.len() as i32 && position_x >= 0 && position_x < map[position_y as usize].len() as i32 {
    if map[position_y as usize][position_x as usize] == Cell::Asteroid {
      found_asteroid = true;
    }
    map[position_y as usize][position_x as usize] = Cell::Examined;

    position_x += direction_x;
    position_y += direction_y;
  }

  (found_asteroid, map)
}

fn visible_asteroids(original_map: &Vec<Vec<Cell>>, x: usize, y: usize) -> u32 {
  if original_map[y as usize][x as usize] == Cell::Empty {
    return 0
  }

  let mut map = original_map.clone();
  let mut result = 0;

  // Check above
  // I miss ranges going reverse - would love to do
  // for to_y in (y-1)..=0 {
  for offset_y in 0..y {
    let to_y = y - 1 - offset_y;
    for to_x in 0..(map[to_y as usize].len() as i32) {
      let (asteroid, new_map) = check_and_mark(map, x, y, to_x - x as i32, to_y as i32 - y as i32);
      map = new_map;
      if asteroid {
        result += 1;
      }
    }
  }

  // Check to the left
  let (asteroid_left, new_map_left) = check_and_mark(map, x, y, -1, 0);
  map = new_map_left;
  if asteroid_left {
    result += 1;
  }

  // Check to the right
  let (asteroid_right, new_map_right) = check_and_mark(map, x, y, 1, 0);
  map = new_map_right;
  if asteroid_right {
    result += 1;
  }

  // Check below
  for to_y in (y+1)..map.len() {
    for to_x in 0..(map[to_y as usize].len() as i32) {
      let (asteroid, new_map) = check_and_mark(map, x, y, to_x - x as i32, to_y as i32 - y as i32);
      map = new_map;
      if asteroid {
        result += 1;
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

  let mut max_asteroids = 0;
  for y in 0..map.len() {
    for x in 0..map[y].len() {
      let visible_for_position = visible_asteroids(&map, x, y);
      if visible_for_position > max_asteroids {
        //println!("{},{}: {} visible", x, y, visible_for_position);
        max_asteroids = visible_for_position;
      }
    }
  }
  println!("Best can see {} asteroids", max_asteroids);

  Ok(())
}
