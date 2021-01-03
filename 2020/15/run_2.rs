use std::collections::HashMap;

fn main() {
  let numbers: Vec<usize> = vec![9,3,1,0,8,4];

  let mut last_spoken_numbers = HashMap::new();

  //let mut last_spoken_numbers = HashMap::new();
  for i in 0..numbers.len()-1 {
    last_spoken_numbers.insert(numbers[i], i);
  }

  let mut last_number = *numbers.last().unwrap();
  for i in numbers.len()..30000000 {
    let last_spoken_at = last_spoken_numbers.get(&last_number);

    let new_number = match last_spoken_at {
      None => 0,
      Some(last_spoken_at) => i - last_spoken_at - 1
    };
  
    last_spoken_numbers.insert(last_number, i-1);
    last_number = new_number
  }

  println!("{}", last_number);
}
