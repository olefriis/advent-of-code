use std::fs::File;
use std::io::{self, BufRead};

fn fetch(program: &Vec<i32>, parameter: usize, parameter_mode: u32) -> i32 {
  match parameter_mode {
    0 => program[program[parameter] as usize],
    1 => program[parameter],
    _ => panic!("Unknown parameter mode {}", parameter_mode)
  }
}

fn run(program: &mut Vec<i32>, inputs: &Vec<i32>) {
  let mut instruction_pointer = 0;
  let mut input_iter = inputs.iter();
  loop {
    let instruction = program[instruction_pointer] as u32;
    let opcode = instruction % 100;
    //let mode_for_parameter_3 = (instruction / 10000) % 10;
    let mode_for_parameter_2 = (instruction / 1000) % 10;
    let mode_for_parameter_1 = (instruction / 100) % 10;
    match opcode {
      99 => return,
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
        println!("Output from instruction {}: {}", instruction_pointer, parameter);
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

fn main() -> std::io::Result<()> {
  let file = File::open("5/input")?;
  let lines: Vec<String> = io::BufReader::new(file).lines().map(|line| line.unwrap()).collect();
  let mut program: Vec<i32> = lines.iter()
    .flat_map(|line| line.split(',').map(|intcode_as_string| intcode_as_string.parse::<i32>().unwrap()))
    .collect();

  let inputs = vec![5];
  run(&mut program, &inputs);

  Ok(())
}
