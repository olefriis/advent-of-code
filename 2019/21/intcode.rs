use std::collections::HashMap;

pub struct Intcode {
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

pub fn read_program(filename: &str) -> Vec<i64> {
  std::fs::read_to_string(filename).unwrap()
    .split(',')
    .map(|intcode_as_string| intcode_as_string.parse::<i64>().unwrap())
    .collect()
}

impl Intcode {
  pub fn new(program: &Vec<i64>) -> Intcode {
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
  
  pub fn run(&mut self, inputs: &Vec<i64>) -> Option<i64> {
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
      ParameterMode::Relative => self.memory_at((self.relative_base as i64 + self.memory[&position]) as usize),
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
