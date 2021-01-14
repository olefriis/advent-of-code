use std::collections::HashMap;
use std::{thread, time};

fn main() -> std::io::Result<()> {
  let mut program: Vec<i64> = std::fs::read_to_string("13/input").unwrap()
    .split(',')
    .map(|intcode_as_string| intcode_as_string.parse::<i64>().unwrap())
    .collect();

  // Insert the coin
  program[0] = 2;

  let mut intcode = Intcode::new(&program);
  let mut screen = HashMap::new();
  let mut joystick = 0;
  let mut score = run_until_score_shown(&mut intcode, &mut screen, joystick);
  println!("Score: {}", score);
  print_screen(&screen);
  auto_update_joystick(&screen, &mut joystick);
  loop {
    run_one_update(&mut intcode, &mut screen, &mut score, joystick);
    print_screen(&screen);
    auto_update_joystick(&screen, &mut joystick);
    //thread::sleep(time::Duration::from_millis(50));
  }
}

fn auto_update_joystick(screen: &HashMap<Position, i64>, joystick: &mut i64) {
  let balls: Vec<(&Position, &i64)> = screen.iter().filter(|(_, &tile_id)| tile_id == 4).collect();
  let paddles: Vec<(&Position, &i64)> = screen.iter().filter(|(_, &tile_id)| tile_id == 3).collect();
  if balls.len() == 1 && paddles.len() == 1 {
    let ball_position = balls[0].0;
    let paddle_position = paddles[0].0;

    if ball_position.x < paddle_position.x {
      *joystick = -1;
    } else if ball_position.x > paddle_position.x {
      *joystick = 1;
    } else {
      *joystick = 0;
    }
  }
}


fn run_one_update(intcode: &mut Intcode, screen: &mut HashMap<Position, i64>, score: &mut i64, joystick: i64) {
  let input = vec![joystick];
  let x = match intcode.run(&input) {
    None => {
      // Hey, we're done!!!
      panic!("Score: {}", score);
    },
    Some(value) => value,
  };
  let y = intcode.run(&input).unwrap();
  let tile_id = intcode.run(&input).unwrap();

  if x == -1 && y ==  0 {
    // tile_id is the score
    *score = tile_id;
    return
  } else {
    screen.insert(Position { x: x, y: y }, tile_id);
  }
}

fn run_until_score_shown(intcode: &mut Intcode, screen: &mut HashMap<Position, i64>, joystick: i64) -> i64 {
  let input = vec![joystick];
  loop {
    let x = intcode.run(&input).unwrap();
    let y = intcode.run(&input).unwrap();
    let tile_id = intcode.run(&input).unwrap();

    if x == -1 && y ==  0 {
      // tile_id is the score
      return tile_id
    }

    screen.insert(Position { x: x, y: y }, tile_id);
  }
}

fn print_screen(screen: &HashMap<Position, i64>) {
  let min_x = screen.keys().map(|position| position.x).min().unwrap();
  let max_x = screen.keys().map(|position| position.x).max().unwrap();
  let min_y = screen.keys().map(|position| position.y).min().unwrap();
  let max_y = screen.keys().map(|position| position.y).max().unwrap();

  for y in min_y..=max_y {
    for x in min_x..=max_x {
      let tile_id = match screen.get(&Position { x: x, y: y }) {
        None => 0,
        Some(value) => *value,
      };
      match tile_id {
        0 => print!(" "), // Empty
        1 => print!("|"), // Wall
        2 => print!("#"), // Block
        3 => print!("-"), // Horizontal paddle
        4 => print!("*"), // Ball
        _ => print!("X"), // Undefined
      };
    }
    println!("")
  }
}

#[derive(PartialEq, Eq, Hash)]
struct Position {
  x: i64,
  y: i64,
}

struct Intcode {
  memory: HashMap<usize, i64>,
  instruction_pointer: usize,
  relative_base: usize,
}

#[derive(Debug)]
enum ParameterMode {
  Position,
  Immediate,
  Relative,
}

impl Intcode {
  fn new(program: &Vec<i64>) -> Intcode {
    let mut memory = HashMap::<usize, i64>::new();
    for (position, m) in program.iter().enumerate() {
      memory.insert(position, *m);
    }

    Intcode {
      memory: memory,
      instruction_pointer: 0,
      relative_base: 0,
    }
  }
  
  fn run(&mut self, inputs: &Vec<i64>) -> Option<i64> {
    let mut input_iter = inputs.iter();
    loop {
      let instruction = self.memory[&self.instruction_pointer] as u64;
      let opcode = instruction % 100;
      match opcode {
        99 => return None,
        1 => self.add(),
        2 => self.multiply(),
        3 => self.store_input(&mut input_iter),
        4 => return self.write_output(),
        5 => self.jump_if_nonzero(),
        6 => self.jump_if_zero(),
        7 => self.compare_less_than(),
        8 => self.compare_equal(),
        9 => self.adjust_relative_base(),
        _ => {
          panic!("Unknown instruction at position {}: {}", self.instruction_pointer, opcode);
        }
      }
    }
  }

  fn add(&mut self) {
    self.store(3, self.parameter(1) + self.parameter(2));
    self.instruction_pointer += 4;
  }

  fn multiply(&mut self) {
    self.store(3, self.parameter(1) * self.parameter(2));
    self.instruction_pointer += 4;
  }

  fn store_input(&mut self, input_iter: &mut std::slice::Iter<i64>) {
    match input_iter.next() {
      Some(input) => {
        self.store(1, *input);
        self.instruction_pointer += 2;
      },
      None => panic!("No more input")
    }
  }

  fn write_output(&mut self) -> Option<i64> {
    let result = Some(self.parameter(1));
    self.instruction_pointer += 2;
    result
  }

  fn jump_if_nonzero(&mut self) {
    if self.parameter(1) != 0 {
      self.instruction_pointer = self.parameter(2) as usize;
    } else {
      self.instruction_pointer += 3;
    }
  }

  fn jump_if_zero(&mut self) {
    if self.parameter(1) == 0 {
      self.instruction_pointer = self.parameter(2) as usize;
    } else {
      self.instruction_pointer += 3;
    }
  }

  fn compare_less_than(&mut self) {
    let result = if self.parameter(1) < self.parameter(2) { 1 } else { 0 };
    self.store(3, result);
    self.instruction_pointer += 4;
  }

  fn compare_equal(&mut self) {
    let result = if self.parameter(1) == self.parameter(2) { 1 } else { 0 };
    self.store(3, result);
    self.instruction_pointer += 4;
  }

  fn adjust_relative_base(&mut self) {
    let new_relative_base = (self.relative_base as i64) + self.parameter(1);
    if new_relative_base < 0 {
      panic!("New relative base is less than 0: {}", new_relative_base);
    }
    self.relative_base = new_relative_base as usize;
    self.instruction_pointer += 2;
  }

  fn parameter(&self, parameter_number: usize) -> i64 {
    let position = self.instruction_pointer + parameter_number;
    match self.parameter_mode(parameter_number) {
      ParameterMode::Position => self.memory_at(self.memory[&position] as usize),
      ParameterMode::Immediate => self.memory_at(position),
      ParameterMode::Relative => self.memory_at(self.relative_base + (self.memory[&position] as usize)),
    }
  }

  fn store(&mut self, parameter_number: usize, value: i64) {
    let position = self.instruction_pointer + parameter_number;
    let destination = match self.parameter_mode(parameter_number) {
      ParameterMode::Position => self.memory_at(position) as usize,
      ParameterMode::Immediate => panic!("Immediate parameter mode not supported for destination parameters"),
      ParameterMode::Relative => (self.relative_base as i64 + self.memory_at(position)) as usize,
    } as usize;

    self.memory.insert(destination, value);
  }

  fn memory_at(&self, position: usize) -> i64 {
    match self.memory.get(&position) {
      None => 0,
      Some(value) => *value,
    }
  }

  fn parameter_mode(&self, parameter_number: usize) -> ParameterMode {
    let instruction = self.memory[&self.instruction_pointer] as usize;
    let mode_number = match parameter_number {
      1 => (instruction / 100) % 10,
      2 => (instruction / 1000) % 10,
      3 => (instruction / 10000) % 10,
      _ => panic!("Unsupported parameter number {}", parameter_number),
    };
    match mode_number {
      0 => ParameterMode::Position,
      1 => ParameterMode::Immediate,
      2 => ParameterMode::Relative,
      _ => panic!("Unknown parameter mode {}", mode_number),
    }
  }
}
