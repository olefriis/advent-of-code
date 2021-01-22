use std::fs::File;
use std::io::{self, BufRead};
use std::collections::{HashMap,HashSet};

type Map = Vec<Vec<char>>;

#[derive(PartialEq, Eq, Clone, Debug, Hash)]
struct Position {
  x: usize,
  y: usize,
}

#[derive(PartialEq, Eq, Clone, Debug, Hash)]
struct MultidimensionalPosition {
  dimension: i32,
  position: Position,
}

struct Portals {
  portals: HashMap<Position, Position>,
  outside_portals: HashSet<Position>,
  start: Position,
  end: Position,
}

fn main() -> std::io::Result<()> {
  let file = File::open("20/input")?;
  let map: Map = io::BufReader::new(file).lines().map(|line| line.unwrap().chars().collect()).collect();

  let portals = parse_portals(&map);

  println!("{} portals, {} on the outside: {:?}", portals.portals.len(), portals.outside_portals.len(), portals.portals);
  println!("Starting at {},{}, ending at {},{}", portals.start.x, portals.start.y, portals.end.x, portals.end.y);

  let mut shortest_paths: HashMap<MultidimensionalPosition, usize> = HashMap::new();
  let mut border: Vec<MultidimensionalPosition> = vec![];
  border.push(MultidimensionalPosition { dimension: 0, position: portals.start.clone() });
  shortest_paths.insert(MultidimensionalPosition { dimension: 0, position: portals.start.clone() }, 0);
  let mut moves = 0;

  while border.len() > 0 {
    let mut new_border = vec![];
    moves += 1;
    for position in border.iter() {
      for offset in vec![(-1,0), (1,0), (0,-1), (0,1)].iter() {
        let mut dimension = position.dimension;
        let nearby_position = Position { x: (position.position.x as i32 + offset.0) as usize, y: (position.position.y as i32 + offset.1) as usize };
        if portals.end == nearby_position && dimension == 0 {
          println!("Got there in {} moves", moves);
          return Ok(())
        }

        let actual_position;
        match portals.portals.get(&nearby_position) {
          None => { actual_position = nearby_position; },
          Some(portal_position) => {
            let is_outside_portal = portals.outside_portals.contains(&nearby_position);
            // Outside portals don't work in dimension 0
            if dimension != 0 || !is_outside_portal {
              dimension += if is_outside_portal { -1 } else { 1 };
              actual_position = portal_position.clone();
            } else {
              actual_position = nearby_position;
            }
          },
        };
        let char_at_position = map[actual_position.y][actual_position.x];
        let new_multidimensional_position = MultidimensionalPosition { dimension, position: actual_position.clone() };
        // AA and ZZ (at portals.start and portals.end, respectively) work only in dimension 0
        if char_at_position == '.' && !shortest_paths.contains_key(&new_multidimensional_position) && (dimension == 0 || (actual_position != portals.start && actual_position != portals.end)) {
          new_border.push(new_multidimensional_position.clone());
          shortest_paths.insert(new_multidimensional_position, moves);
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
  let mut outside_portals: HashSet<Position> = HashSet::new();
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
      if destination.y == 2 || destination.y == map.len()-3 || destination.x == 2 || destination.x == map[0].len()-3 {
        outside_portals.insert(position.clone());
      }
    }
  }

  Portals {
    portals,
    outside_portals,
    start: start.unwrap().clone(),
    end: end.unwrap().clone(),
  }
}
