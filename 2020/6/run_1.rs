use std::fs;
use std::collections::BTreeSet;

fn main() -> std::io::Result<()> {
  let input = fs::read_to_string("input")?;

  let groups: Vec<&str> = input.split("\n\n").collect();

  let mut result = 0;
  for group in groups {
    let mut answers = BTreeSet::new();
    for answer in group.chars() {
      if answer >= 'a' && answer <= 'z' {
        answers.insert(answer);
      }
    }
    result += answers.len();
  }

  println!("Result: {}", result);

  Ok(())
}