use std::fs::File;
use std::io::{self, BufRead};
use std::collections::HashSet;

#[derive(PartialEq, Clone)]
enum Cell {
  Asteroid,
  Empty,
  Examined,
}

#[derive(PartialEq, Eq, Hash, Clone, Debug)]
struct Position {
  x: usize,
  y: usize,
}

struct OrderedFloat {
  f: f64,
}

impl PartialEq for OrderedFloat {
  fn eq(&self, other: &Self) -> bool {
      self.f == other.f
  }
}

impl Eq for OrderedFloat {}

impl std::cmp::Ord for OrderedFloat {
  fn cmp(&self, other: &Self) -> std::cmp::Ordering {
    self.f.partial_cmp(&other.f).unwrap()
  }
}

impl std::cmp::PartialOrd for OrderedFloat {
  fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
      Some(self.cmp(other))
  }
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

  let vaporized = vaporize(&map, &best_position);
  vaporized.iter().enumerate().for_each(|(index, position)| {
    println!("{}: {:?}", index, position);
  });

  let relevant_position = &vaporized[199];
  println!("200th asteroid to be vaporized: {},{} - so the answer is {}", relevant_position.x, relevant_position.y, relevant_position.x * 100 + relevant_position.y);

  Ok(())
}

fn vaporize(initial_map: &Vec<Vec<Cell>>, position: &Position) -> Vec<Position> {
  let mut working_map = initial_map.clone();
  let mut result = Vec::new();

  loop {
    let visible_asteroids = visible_asteroids(&working_map, position);
    if visible_asteroids.len() == 0 {
      break;
    }

    // First vaporize the top right quater of the map, including the column just above our position
    let mut upper_right = visible_asteroids.iter()
      .filter(|asteroid| asteroid.x >= position.x && asteroid.y < position.y)
      .collect::<Vec<&Position>>();
    upper_right.sort_by_key(|asteroid| OrderedFloat { f: (asteroid.x as f64 - position.x as f64) / (position.y as f64 - asteroid.y as f64) });

    // Then vaporize the bottom right of the map, including the row to the right of our position but excluding our column
    let mut lower_right = visible_asteroids.iter()
      .filter(|asteroid| asteroid.x > position.x && asteroid.y >= position.y)
      .collect::<Vec<&Position>>();
    lower_right.sort_by_key(|asteroid| OrderedFloat { f: (asteroid.y as f64 - position.y as f64) / (asteroid.x as f64 - position.x as f64) });

    // Then the lower left - including "our column", but exlucing "our row"
    let mut lower_left = visible_asteroids.iter()
      .filter(|asteroid| asteroid.x <= position.x && asteroid.y > position.y)
      .collect::<Vec<&Position>>();
    lower_left.sort_by_key(|asteroid| OrderedFloat { f: (position.x as f64 - asteroid.x as f64) / (asteroid.y as f64 - position.y as f64) });

    // Finally the upper left - including "our row", but exluding the column just above our position
    let mut upper_left = visible_asteroids.iter()
      .filter(|asteroid| asteroid.x < position.x && asteroid.y <= position.y)
      .collect::<Vec<&Position>>();
    upper_left.sort_by_key(|asteroid| OrderedFloat { f: (position.y as f64 - asteroid.y as f64) / (position.x as f64 - asteroid.x as f64) });

    // Add all vaporized asteroids to our result, and remove them from our working map
    upper_right.iter()
      .chain(lower_right.iter())
      .chain(lower_left.iter())
      .chain(upper_left.iter())
      .for_each(|&position| {
        result.push(position.clone());
        working_map[position.y][position.x] = Cell::Empty;
      });
  }

  result
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

fn check_and_mark(map: &mut Vec<Vec<Cell>>, origin: &Position, direction_x: i32, direction_y: i32) -> Option<Position> {
  let mut found_asteroid = None;

  let mut position_x = origin.x as i32 + direction_x;
  let mut position_y = origin.y as i32 + direction_y;
  while position_y >= 0 && position_y < map.len() as i32 && position_x >= 0 && position_x < map[position_y as usize].len() as i32 {
    if found_asteroid == None && map[position_y as usize][position_x as usize] == Cell::Asteroid {
      found_asteroid = Some(Position { x: position_x as usize, y: position_y as usize });
    }
    map[position_y as usize][position_x as usize] = Cell::Examined;

    position_x += direction_x;
    position_y += direction_y;
  }

  found_asteroid
}
