use std::fs::File;
use std::io::{self, BufRead};
use std::collections::HashSet;

fn fetch(program: &Vec<i32>, parameter: usize, parameter_mode: u32) -> i32 {
  match parameter_mode {
    0 => program[program[parameter] as usize],
    1 => program[parameter],
    _ => panic!("Unknown parameter mode {}", parameter_mode)
  }
}

struct Intcode {
  program: Vec<i32>,
  instruction_pointer: usize,
}

impl Intcode {
  fn new(program: &Vec<i32>) -> Intcode {
    Intcode {
      program: program.clone(),
      instruction_pointer: 0,
    }
  }

  fn run(&mut self, inputs: &Vec<i32>) -> Option<i32> {
    let mut input_iter = inputs.iter();
    loop {
      let instruction = self.program[self.instruction_pointer] as u32;
      let opcode = instruction % 100;
      //let mode_for_parameter_3 = (instruction / 10000) % 10;
      let mode_for_parameter_2 = (instruction / 1000) % 10;
      let mode_for_parameter_1 = (instruction / 100) % 10;
      match opcode {
        99 => return None,
        1 => {
          let parameter1 = fetch(&self.program, self.instruction_pointer+1, mode_for_parameter_1);
          let parameter2 = fetch(&self.program, self.instruction_pointer+2, mode_for_parameter_2);
          let destination = self.program[self.instruction_pointer+3] as usize;
          self.program[destination] = parameter1 + parameter2;
          self.instruction_pointer += 4;
        },
        2 => {
          let parameter1 = fetch(&self.program, self.instruction_pointer+1, mode_for_parameter_1);
          let parameter2 = fetch(&self.program, self.instruction_pointer+2, mode_for_parameter_2);
          let destination = self.program[self.instruction_pointer+3] as usize;
          self.program[destination] = parameter1 * parameter2;
          self.instruction_pointer += 4;
        },
        3 => {
          match input_iter.next() {
            Some(input) => {
              let destination = self.program[self.instruction_pointer + 1] as usize;
              self.program[destination] = *input;
              self.instruction_pointer += 2;
            },
            None => panic!("No more input")
          }
        },
        4 => {
          let parameter = fetch(&self.program, self.instruction_pointer+1, mode_for_parameter_1);
          self.instruction_pointer += 2;
          return Some(parameter);
        },
        5 => {
          let parameter1 = fetch(&self.program, self.instruction_pointer+1, mode_for_parameter_1);
          let parameter2 = fetch(&self.program, self.instruction_pointer+2, mode_for_parameter_2);
          if parameter1 != 0 {
            self.instruction_pointer = parameter2 as usize;
          } else {
            self.instruction_pointer += 3;
          }
        },
        6 => {
          let parameter1 = fetch(&self.program, self.instruction_pointer+1, mode_for_parameter_1);
          let parameter2 = fetch(&self.program, self.instruction_pointer+2, mode_for_parameter_2);
          if parameter1 == 0 {
            self.instruction_pointer = parameter2 as usize;
          } else {
            self.instruction_pointer += 3;
          }
        },
        7 => {
          let parameter1 = fetch(&self.program, self.instruction_pointer+1, mode_for_parameter_1);
          let parameter2 = fetch(&self.program, self.instruction_pointer+2, mode_for_parameter_2);
          let destination = self.program[self.instruction_pointer+3] as usize;
          let result = if parameter1 < parameter2 { 1 } else { 0 };
          self.program[destination] = result;
          self.instruction_pointer += 4;
        },
        8 => {
          let parameter1 = fetch(&self.program, self.instruction_pointer+1, mode_for_parameter_1);
          let parameter2 = fetch(&self.program, self.instruction_pointer+2, mode_for_parameter_2);
          let destination = self.program[self.instruction_pointer+3] as usize;
          let result = if parameter1 == parameter2 { 1 } else { 0 };
          self.program[destination] = result;
          self.instruction_pointer += 4;
        },
        _ => {
          panic!("Unknown instruction at position {}: {}", self.instruction_pointer, opcode);
        }
      }
    }
  }
}

fn all_combinations_of(elements: &HashSet<i32>) -> HashSet<Vec<i32>> {
  let mut result = HashSet::<Vec<i32>>::new();
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
  let original_program: Vec<i32> = lines.iter()
    .flat_map(|line| line.split(',').map(|intcode_as_string| intcode_as_string.parse::<i32>().unwrap()))
    .collect();

  let mut elements = HashSet::new();
  elements.insert(5);
  elements.insert(6);
  elements.insert(7);
  elements.insert(8);
  elements.insert(9);
  let combinations = all_combinations_of(&elements);

  let mut max_thruster_signal: Option<i32> = None;
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
