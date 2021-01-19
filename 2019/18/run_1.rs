use std::fs::File;
use std::io::{self, BufRead};
use std::collections::{HashMap, HashSet};

fn main() -> std::io::Result<()> {
  let file = File::open("18/test_input_2")?;
  let map: Map = io::BufReader::new(file).lines().map(|line| line.unwrap().chars().collect()).collect();

  let all_keys: Vec<&char> = map.iter().flat_map(|line| line.iter().filter(|c| is_key(c))).collect();

  println!("{} keys", all_keys.len());

  let starting_y = map.iter().enumerate().find(|(_, line)| line.contains(&'@')).unwrap().0;
  let starting_x = map[starting_y].iter().enumerate().find(|(_, c)| c == &&'@').unwrap().0;
  let starting_position = Position { x: starting_x, y: starting_y };

  println!("Starting at {:?}", starting_position);

  let mut players = vec![Player::new(&starting_position)];
  let mut iteration = 0;

  while players.len() > 0 {
    iteration += 1;
    println!("Iteration {}. We have {} players.", iteration, players.len());
    let mut next_players = vec![];

    for player in players {
      let possible_destinations = reachable_keys(&map, &player.position, &player.keys);
      for key in possible_destinations.keys() {
        let (position, moves) = possible_destinations.get(key).unwrap();
        let new_player = player.moved_to(position, key, *moves);
        if new_player.number_of_keys() == all_keys.len() {
          println!("Found all keys: {:?}", new_player);
        } else {
          next_players.push(new_player);
        }
      }
    }

    players = next_players;
  }

  Ok(())
}

fn reachable_keys(map: &Map, position: &Position, current_keys: &Vec<Key>) -> HashMap<Key, (Position, usize)> {
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
        result.insert(tile, (position.clone(), distance));
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

#[derive(PartialEq, Eq, Clone, Debug)]
struct Player {
  moves: usize,
  position: Position,
  keys: Keys,
}

impl Player {
  fn new(position: &Position) -> Player {
    Player {
      moves: 0,
      position: position.clone(),
      keys: Keys::new(),
    }
  }

  fn moved_to(&self, position: &Position, new_key: &Key, moves: usize) -> Player {
    let mut keys = self.keys.clone();
    keys.push(new_key.clone());
    Player {
      moves: self.moves + moves,
      position: position.clone(),
      keys,
    }
  }

  fn has_key(&self, key: &Key) -> bool {
    self.keys.contains(key)
  }

  fn number_of_keys(&self) -> usize {
    self.keys.len()
  }
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