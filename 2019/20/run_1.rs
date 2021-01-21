use std::fs::File;
use std::io::{self, BufRead};
use std::collections::HashMap;

type Map = Vec<Vec<char>>;

#[derive(PartialEq, Eq, Clone, Debug, Hash)]
struct Position {
  x: usize,
  y: usize,
}

struct Portals {
  portals: HashMap<Position, Position>,
  start: Position,
  end: Position,
}

fn main() -> std::io::Result<()> {
  let file = File::open("20/input")?;
  let map: Map = io::BufReader::new(file).lines().map(|line| line.unwrap().chars().collect()).collect();

  let portals = parse_portals(&map);

  println!("{} portals: {:?}", portals.portals.len(), portals.portals);
  println!("Starting at {},{}, ending at {},{}", portals.start.x, portals.start.y, portals.end.x, portals.end.y);

  let mut shortest_paths = HashMap::new();
  let mut border = vec![];
  border.push(portals.start.clone());
  shortest_paths.insert(portals.start.clone(), 0);
  let mut moves = 0;

  while border.len() > 0 {
    let mut new_border = vec![];
    moves += 1;
    for position in border.iter() {
      for offset in vec![(-1,0), (1,0), (0,-1), (0,1)].iter() {
        let nearby_position = Position { x: (position.x as i32 + offset.0) as usize, y: (position.y as i32 + offset.1) as usize };
        if portals.end == nearby_position {
          println!("Got there in {} moves", moves);
          return Ok(())
        }

        let actual_position = match portals.portals.get(&nearby_position) {
          None => nearby_position,
          Some(portal_position) => portal_position.clone(),
        };
        let char_at_position = map[actual_position.y][actual_position.x];
        if char_at_position == '.' && !shortest_paths.contains_key(&actual_position) {
          new_border.push(actual_position.clone());
          shortest_paths.insert(actual_position, moves);
        }
      }
    }

    border = new_border;
  }

  Ok(())
}

fn parse_portals(map: &Map) -> Portals{
  let mut portal_positions = HashMap::new();
  for y in 1..map.len()-1 {
    for x in 1..map[y].len()-1 {
      let c = map[y][x];
      if c.is_ascii_uppercase() {
        let mut portal_name = None;
        let mut destination = None;
        if map[y-1][x] == '.' {
          portal_name = Some(vec![c.to_string(), map[y+1][x].to_string()].join(""));
          destination = Some(Position { x, y: y-1 });
        } else if map[y+1][x] == '.' {
          portal_name = Some(vec![map[y-1][x].to_string(), c.to_string()].join(""));
          destination = Some(Position { x, y: y+1 });
        } else if map[y][x-1] == '.' {
          portal_name = Some(vec![c.to_string(), map[y][x+1].to_string()].join(""));
          destination = Some(Position { x: x-1, y });
        } else if map[y][x+1] == '.' {
          portal_name = Some(vec![map[y][x-1].to_string(), c.to_string()].join(""));
          destination = Some(Position { x: x+1, y });
        }
        if let Some(portal_name) = portal_name {
          let position = Position { x, y };
          portal_positions.insert(position, (portal_name, destination.unwrap()));
        }
      }
    }
  }

  // Not the prettiest way of assembling this, but... shrug...
  let mut portals: HashMap<Position, Position> = HashMap::new();
  let mut start = None;
  let mut end = None;
  for (position, (name, destination)) in portal_positions.iter() {
    if name == "AA" {
      start = Some(destination);
    } else if name == "ZZ" {
      end = Some(destination);
    } else {
      let other_destination = &portal_positions.iter().find(|(other_position, (other_name, _other_destination))| name == other_name && other_position != &position).unwrap().1.1;
      portals.insert(position.clone(), other_destination.clone());
    }
  }

  Portals {
    portals,
    start: start.unwrap().clone(),
    end: end.unwrap().clone(),
  }
}
