use std::fs::File;
use std::io::{self, BufRead};

fn main() -> std::io::Result<()> {
  let file = File::open("12/input")?;
  let lines: Vec<String> = io::BufReader::new(file).lines().map(|line| line.unwrap()).collect();
  let mut moons: Vec<Moon> = lines.iter().map(|line| parse_moon(line)).collect();

  println!("Got {} moons", moons.len());

  for _ in 0..1000 {
    moons = update_velocities(&moons);
    moons = update_positions(&moons);
  }

  let kinetic_energy: i32 = moons.iter().map(|moon| moon.kinetic_energy()).sum();

  println!("Kinetic energy: {}", kinetic_energy);

  Ok(())
}

struct Moon {
  position: Vector3D,
  velocity: Vector3D,
}

impl Moon {
  fn kinetic_energy(&self) -> i32 {
    (self.position.x.abs() + self.position.y.abs() + self.position.z.abs()) *
    (self.velocity.x.abs() + self.velocity.y.abs() + self.velocity.z.abs())
  }
}

#[derive(Clone)]
struct Vector3D {
  x: i32,
  y: i32,
  z: i32,
}

fn update_velocities(moons: &Vec<Moon>) -> Vec<Moon> {
  moons.iter().enumerate().map(|(index, moon)| {
    let mut velocity = moon.velocity.clone();
    moons.iter().enumerate().for_each(|(other_index, other_moon)| {
      if index != other_index {
        velocity = updated_velocity(&velocity, &moon, &other_moon).clone();
      }
    });
    Moon { position: moon.position.clone(), velocity: velocity.clone() }
  }).collect()
}

fn update_positions(moons: &Vec<Moon>) -> Vec<Moon> {
  moons.iter().map(|moon| {
    Moon {
      position: Vector3D {
        x: moon.position.x + moon.velocity.x,
        y: moon.position.y + moon.velocity.y,
        z: moon.position.z + moon.velocity.z,
      },
      velocity: moon.velocity.clone(),
    }
  }).collect()
}

fn updated_velocity(velocity: &Vector3D, moon: &Moon, other_moon: &Moon) -> Vector3D {
  Vector3D {
    x: updated_velocity_component(velocity.x, moon.position.x, other_moon.position.x),
    y: updated_velocity_component(velocity.y, moon.position.y, other_moon.position.y),
    z: updated_velocity_component(velocity.z, moon.position.z, other_moon.position.z),
  }
}

fn updated_velocity_component(velocity: i32, position: i32, other_position: i32) -> i32 {
  if position < other_position {
    velocity + 1
  } else if position > other_position {
    velocity - 1
  } else {
    velocity
  }
}

fn parse_moon(line: &str) -> Moon {
  let mut components = line.strip_prefix("<").unwrap().strip_suffix(">").unwrap().split(", ");
  let x = parse_number(components.next().unwrap());
  let y = parse_number(components.next().unwrap());
  let z = parse_number(components.next().unwrap());
  Moon {
    position: Vector3D { x: x, y: y, z: z },
    velocity: Vector3D { x: 0, y: 0, z: 0 },
  }
}

fn parse_number(s: &str) -> i32 {
  let mut components = s.split("=");
  components.next();
  components.next().unwrap().parse().unwrap()
}
