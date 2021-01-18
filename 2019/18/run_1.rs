use std::fs::File;
use std::io::{self, BufRead};
use std::collections::{HashMap, HashSet};

fn main() -> std::io::Result<()> {
  let file = File::open("18/altered_input")?;
  let lines: Vec<Vec<char>> = io::BufReader::new(file).lines().map(|line| line.unwrap().chars().collect()).collect();

  let all_keys: Vec<&char> = lines.iter().flat_map(|line| line.iter().filter(|c| is_key(c))).collect();

  println!("{} keys", all_keys.len());

  let starting_y = lines.iter().enumerate().find(|(_, line)| line.contains(&'@')).unwrap().0;
  let starting_x = lines[starting_y].iter().enumerate().find(|(_, c)| c == &&'@').unwrap().0;
  let starting_position = Position { x: starting_x, y: starting_y };

  println!("Starting at {:?}", starting_position);

  let mut players = vec![Player::new(&starting_position)];
  let mut iteration = 0;

  loop {
    iteration += 1;
    println!("Iteration {}. We have {} players.", iteration, players.len());
    let mut next_players = vec![];

    for player in players {
      for nearby_offset in vec![(-1, 0), (1, 0), (0, -1), (0, 1)].iter() {
        let new_position = Position { x: (player.position.x as i32 + nearby_offset.0) as usize, y: (player.position.y as i32 + nearby_offset.1) as usize };
        let tile_at_new_position = lines[new_position.y][new_position.x];
        if player.can_walk_to(&new_position, &tile_at_new_position) {
          let mut moved_player = player.moved_to(&new_position);
          if is_key(&tile_at_new_position) && !player.has_key(&tile_at_new_position) {
            moved_player = moved_player.with_new_key(&tile_at_new_position);
            if moved_player.number_of_keys() == all_keys.len() {
              println!("Player made it in {} moves! {:?}", moved_player.moves, moved_player.keys);
              return Ok(())
            }
          }
          next_players.push(moved_player);
        }
      }

    }

    players = next_players;
  }
}

fn reachable_keys(position: &Position, current_keys: &Vec<Key>) -> HashMap<Key, (Position, usize)> {
  let mut border = vec![];
  let mut investigated = HashSet::new();
  let mut result = HashMap::new();

  while border.len() > 0 {
    let mut new_border = vec![];
    for position in border.iter() {
      for nearby_offset in vec![(-1, 0), (1, 0), (0, -1), (0, 1)].iter() {
        let new_position = Position { x: (position.x as i32 + nearby_offset.0) as usize, y: (position.y as i32 + nearby_offset.1) as usize };

        new_border.push(new_position);
      }
    }
    border = new_border;
  }

  result
}

#[derive(PartialEq, Eq, Clone)]
struct Player {
  moves: usize,
  position: Position,
  do_not_go_back_to: Positions,
  keys: Keys,
}

impl Player {
  fn new(position: &Position) -> Player {
    Player {
      moves: 0,
      position: position.clone(),
      do_not_go_back_to: Positions::new(),
      keys: Keys::new(),
    }
  }

  fn moved_to(&self, position: &Position) -> Player {
    let mut do_not_go_back_to = self.do_not_go_back_to.clone();
    do_not_go_back_to.push(self.position.clone());
    Player {
      moves: self.moves + 1,
      position: position.clone(),
      do_not_go_back_to,
      keys: self.keys.clone(),
    }
  }

  fn with_new_key(&self, key: &Key) -> Player {
    let mut keys = self.keys.clone();
    keys.push(key.clone());
    Player {
      moves: self.moves,
      position: self.position.clone(),
      do_not_go_back_to: Positions::new(),
      keys,
    }
  }

  fn has_key(&self, key: &Key) -> bool {
    self.keys.contains(key)
  }

  fn number_of_keys(&self) -> usize {
    self.keys.len()
  }

  fn can_walk_to(&self, position: &Position, tile: &Tile) -> bool {
    !self.do_not_go_back_to.contains(position) && (tile == &'@' || tile == &'.' || is_key(tile) || self.keys.contains(&tile.to_ascii_lowercase()))
  }
}

#[derive(PartialEq, Eq, Clone, Debug)]
struct Position {
  x: usize,
  y: usize,
}

type Positions = Vec<Position>;
type Key = char;
type Keys = Vec<Key>;
type Tile = char;

fn is_key(c: &char) -> bool {
  c.is_ascii_lowercase()
}
