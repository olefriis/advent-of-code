use std::fs::File;
use std::io::{self, BufRead};
use std::collections::{HashMap, HashSet};

fn main() -> std::io::Result<()> {
  let file = File::open("18/input")?;
  let map: Map = io::BufReader::new(file).lines().map(|line| line.unwrap().chars().collect()).collect();

  let all_keys: Vec<&char> = map.iter().flat_map(|line| line.iter().filter(|c| is_key(c))).collect();
  let mut all_keys_sorted = all_keys.clone();
  all_keys_sorted.sort();
  println!("All keys: {:?}", all_keys_sorted);
  let all_doors: Vec<&char> = map.iter().flat_map(|line| line.iter().filter(|c| is_door(c))).collect();
  println!("All doors: {:?}", all_doors);
  let all_keys_cloned = all_keys.clone();
  let final_keys: Vec<&&char> = all_keys_cloned.iter().filter(|key| !all_doors.contains(&&door_for_key(key))).collect();
  println!("Final keys: {:?}", final_keys);

  println!("{} keys", all_keys.len());

  let mut positions = HashMap::new();
  for y in 0..map.len() {
    for x in 0..map[y].len() {
      positions.insert(map[y][x].clone(), Position { x, y });
    }
  }

  let mut best_efforts_for_keys: HashMap<Tile, HashMap<Vec<Key>, BestEffort>> = HashMap::new();
  for key in all_keys.iter() {
    best_efforts_for_keys.insert(**key, HashMap::new());
  }

  // Initially, all we do is standing at @ with no keys and have spent no moves
  let best_effort_for_starting_position = BestEffort { keys: vec![], moves: 0 };
  let mut best_efforts_for_starting_position = BestEfforts::new();
  best_efforts_for_starting_position.insert(vec![], best_effort_for_starting_position);
  best_efforts_for_keys.insert('@', best_efforts_for_starting_position);

  loop {
    println!("Iterating");
    let iteration = iterate(&map, best_efforts_for_keys, &positions);
    best_efforts_for_keys = iteration.0;
    let changes = iteration.1;

    if changes == 0 {
      break
    }
  }

  //println!("Best effort for z: {:?}", best_efforts_for_keys.get(&'z'));
  for key in all_keys.iter() {
    let best_efforts_for_key: &BestEfforts = best_efforts_for_keys.get(key).unwrap();
    for (keys, best_effort) in best_efforts_for_key.iter() {
      if keys.len() == all_keys.len() {
        println!("Key: {}. Moves: {} ({:?})", key, best_effort.moves, best_effort.keys);
      }
    }
  }

  Ok(())
}

fn iterate(map: &Map, best_efforts_for_keys: HashMap<Tile, BestEfforts>, positions: &HashMap<Key, Position>) -> (HashMap<Tile, HashMap<Vec<Key>, BestEffort>>, usize) {
  let mut changes = 0;
  let previous_keys_to_be_cloned: Vec<&Tile> = best_efforts_for_keys.keys().collect();
  let previous_keys = previous_keys_to_be_cloned.clone();

  let mut new_best_efforts_for_keys = best_efforts_for_keys.clone();

  for key in previous_keys.iter() {
    let position = positions.get(key).unwrap();
    let best_efforts = new_best_efforts_for_keys.get(key).unwrap().clone();
    for keys_collected in best_efforts.keys() {
      let best_effort = best_efforts.get(keys_collected).unwrap();

      let possible_destinations = reachable_keys(&map, &position, &best_effort.keys);
      for key in possible_destinations.keys() {
        let moves = possible_destinations.get(key).unwrap();
        let mut new_keys = best_effort.keys.clone();
        new_keys.push(key.clone());
        let mut sorted_keys = new_keys.clone();
        sorted_keys.sort();

        let possible_best_effort = BestEffort { keys: new_keys, moves: best_effort.moves + moves };

        // Find existing best effort for arriving at the key with `sorted_keys` keys
        let mut best_efforts_for_key = new_best_efforts_for_keys.get_mut(key).unwrap();
        match best_efforts_for_key.get(&sorted_keys) {
          None => {
            best_efforts_for_key.insert(sorted_keys, possible_best_effort);
            changes += 1;
          },
          Some(previous_best_effort) => {
            if previous_best_effort.moves > possible_best_effort.moves {
              best_efforts_for_key.insert(sorted_keys, possible_best_effort);
              changes += 1;
            }
          }
        }
      }
    }
  }

  (new_best_efforts_for_keys, changes)
}

type BestEfforts = HashMap<Vec<char>, BestEffort>;

#[derive(PartialEq, Eq, Clone, Debug, Hash)]
struct BestEffort {
  keys: Vec<char>,
  moves: usize,
}

fn reachable_keys(map: &Map, position: &Position, current_keys: &Vec<Key>) -> HashMap<Key, usize> {
  let mut border = vec![position.clone()];
  let mut investigated: HashSet<Position> = HashSet::new();
  let mut result = HashMap::new();
  let mut distance = 0;

  while border.len() > 0 {
    let mut new_border = vec![];
    for position in border.iter() {
      let tile = map[position.y][position.x];
      if is_key(&tile) && !current_keys.contains(&tile) {
        // We reached a destination. Don't examine neighbours
        result.insert(tile, distance);
      } else {
        for nearby_offset in vec![(-1, 0), (1, 0), (0, -1), (0, 1)].iter() {
          let new_position = Position { x: (position.x as i32 + nearby_offset.0) as usize, y: (position.y as i32 + nearby_offset.1) as usize };
          if !investigated.contains(&new_position) {
            investigated.insert(new_position.clone());
            let nearby_tile = map[new_position.y][new_position.x];
            if nearby_tile == '#' || (is_door(&nearby_tile) && !current_keys.contains(&key_for_door(&nearby_tile))) {
              // No reason to check out this tile
            } else {
              new_border.push(new_position);
            }
          }
        }
      }
    }
    border = new_border;
    distance += 1;
  }

  result
}

#[derive(PartialEq, Eq, Clone, Debug, Hash)]
struct Position {
  x: usize,
  y: usize,
}

type Map = Vec<Vec<Tile>>;
type Key = char;
type Keys = Vec<Key>;
type Tile = char;

fn is_key(c: &Tile) -> bool {
  c.is_ascii_lowercase()
}

fn is_door(c: &Tile) -> bool {
  c.is_ascii_uppercase()
}

fn key_for_door(c: &Tile) -> Tile {
  c.to_ascii_lowercase()
}

fn door_for_key(c: &Tile) -> Tile {
  c.to_ascii_uppercase()
}