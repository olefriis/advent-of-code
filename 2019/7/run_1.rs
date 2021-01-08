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

fn run(program: &mut Vec<i32>, inputs: &Vec<i32>) -> Vec<i32> {
  let mut instruction_pointer = 0;
  let mut input_iter = inputs.iter();
  let mut result = Vec::<i32>::new();
  loop {
    let instruction = program[instruction_pointer] as u32;
    let opcode = instruction % 100;
    //let mode_for_parameter_3 = (instruction / 10000) % 10;
    let mode_for_parameter_2 = (instruction / 1000) % 10;
    let mode_for_parameter_1 = (instruction / 100) % 10;
    match opcode {
      99 => return result,
      1 => {
        let parameter1 = fetch(&program, instruction_pointer+1, mode_for_parameter_1);
        let parameter2 = fetch(&program, instruction_pointer+2, mode_for_parameter_2);
        let destination = program[instruction_pointer+3] as usize;
        program[destination] = parameter1 + parameter2;
        instruction_pointer += 4;
      },
      2 => {
        let parameter1 = fetch(&program, instruction_pointer+1, mode_for_parameter_1);
        let parameter2 = fetch(&program, instruction_pointer+2, mode_for_parameter_2);
        let destination = program[instruction_pointer+3] as usize;
        program[destination] = parameter1 * parameter2;
        instruction_pointer += 4;
      },
      3 => {
        match input_iter.next() {
          Some(input) => {
            let destination = program[instruction_pointer + 1] as usize;
            program[destination] = *input;
            instruction_pointer += 2;
          },
          None => panic!("No more input")
        }
      },
      4 => {
        let parameter = fetch(&program, instruction_pointer+1, mode_for_parameter_1);
        result.push(parameter);
        instruction_pointer += 2;
      },
      5 => {
        let parameter1 = fetch(&program, instruction_pointer+1, mode_for_parameter_1);
        let parameter2 = fetch(&program, instruction_pointer+2, mode_for_parameter_2);
        if parameter1 != 0 {
          instruction_pointer = parameter2 as usize;
        } else {
          instruction_pointer += 3;
        }
      },
      6 => {
        let parameter1 = fetch(&program, instruction_pointer+1, mode_for_parameter_1);
        let parameter2 = fetch(&program, instruction_pointer+2, mode_for_parameter_2);
        if parameter1 == 0 {
          instruction_pointer = parameter2 as usize;
        } else {
          instruction_pointer += 3;
        }
      },
      7 => {
        let parameter1 = fetch(&program, instruction_pointer+1, mode_for_parameter_1);
        let parameter2 = fetch(&program, instruction_pointer+2, mode_for_parameter_2);
        let destination = program[instruction_pointer+3] as usize;
        let result = if parameter1 < parameter2 { 1 } else { 0 };
        program[destination] = result;
        instruction_pointer += 4;
      },
      8 => {
        let parameter1 = fetch(&program, instruction_pointer+1, mode_for_parameter_1);
        let parameter2 = fetch(&program, instruction_pointer+2, mode_for_parameter_2);
        let destination = program[instruction_pointer+3] as usize;
        let result = if parameter1 == parameter2 { 1 } else { 0 };
        program[destination] = result;
        instruction_pointer += 4;
      },
      _ => {
        panic!("Unknown instruction at position {}: {}", instruction_pointer, opcode);
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
  elements.insert(0);
  elements.insert(1);
  elements.insert(2);
  elements.insert(3);
  elements.insert(4);
  let combinations = all_combinations_of(&elements);

  let mut max_thruster_signal: Option<i32> = None;
  for phase_settings in combinations {
    let mut input_signal: i32 = 0;
    for phase_setting in phase_settings {
      let mut program = original_program.clone();
      let inputs: Vec<i32> = vec![phase_setting, input_signal];
      let output = run(&mut program, &inputs);
      if output.len() != 1 {
        panic!("Got {} outputs", output.len());
      }
      input_signal = *output.iter().next().unwrap();
    }
    max_thruster_signal = match max_thruster_signal {
      None => Some(input_signal),
      Some(previous_max_thruster) => Some(if input_signal > previous_max_thruster { input_signal } else { previous_max_thruster })
    }
  }

  println!("Max thruster signal: {:?}", max_thruster_signal);

  Ok(())
}
