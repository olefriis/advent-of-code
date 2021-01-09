use std::fs::File;
use std::io::{self, BufRead};
use std::collections::{HashMap, HashSet};

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
      ParameterMode::Relative => self.relative_base + position,
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

fn all_combinations_of(elements: &HashSet<i64>) -> HashSet<Vec<i64>> {
  let mut result = HashSet::<Vec<i64>>::new();
  if elements.len() == 1 {
    result.insert(vec![*elements.iter().next().unwrap()]);
  } else {
    for element in elements.iter() {
      let mut remaining_elements = elements.clone();
      remaining_elements.remove(element);
      for combinations_without_element in all_combinations_of(&remaining_elements) {
        let mut complete_vector = combinations_without_element.clone();
        complete_vector.push(*element);
        result.insert(complete_vector);
      }
    }
  }

  result
}

fn main() -> std::io::Result<()> {
  let file = File::open("7/input")?;
  let lines: Vec<String> = io::BufReader::new(file).lines().map(|line| line.unwrap()).collect();
  let original_program: Vec<i64> = lines.iter()
    .flat_map(|line| line.split(',').map(|intcode_as_string| intcode_as_string.parse::<i64>().unwrap()))
    .collect();

  let mut elements = HashSet::new();
  elements.insert(5);
  elements.insert(6);
  elements.insert(7);
  elements.insert(8);
  elements.insert(9);
  let combinations = all_combinations_of(&elements);

  let mut max_thruster_signal: Option<i64> = None;
  for phase_settings in combinations {
    let mut input_signal = 0;
    let mut intcodes: Vec<Intcode> = phase_settings.iter().map(|_| Intcode::new(&original_program)).collect();
    let mut initial_run = true;
    loop {
      let output_signal = phase_settings
        .iter()
        .zip(intcodes.iter_mut())
        .fold(Some(input_signal), |input_signal, (phase_setting, intcode)| {
          match input_signal {
            None => None,
            Some(input_signal) => {
              let inputs = if initial_run { vec![*phase_setting, input_signal] } else { vec![input_signal] };
              intcode.run(&inputs)
            }
          }
        });
      initial_run = false;
      match output_signal {
        None => {
          // We're done now!
          max_thruster_signal = match max_thruster_signal {
            None => Some(input_signal),
            Some(previous_max_thruster) => Some(if input_signal > previous_max_thruster { input_signal } else { previous_max_thruster }),
          };
          break;
        },
        Some(output) => { input_signal = output; }
      }
    }
  }

  println!("Max thruster signal: {:?}", max_thruster_signal);

  Ok(())
}
