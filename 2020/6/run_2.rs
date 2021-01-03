use std::fs;
use std::collections::BTreeSet;

fn main() -> std::io::Result<()> {
  let input = fs::read_to_string("input")?;

  let groups: Vec<&str> = input.split("\n\n").collect();

  let mut result = 0;
  for group in groups {
    let mut answers = None;

    for line in group.split("\n") {
      let mut answers_for_member = BTreeSet::new();
      for c in line.chars() {
        answers_for_member.insert(c);
      }
      answers = match answers {
        None => Some(answers_for_member),
        Some(a) => Some(intersection(&a, &answers_for_member))
      }
    }
    result += match answers {
      None => 0,
      Some(a) => a.len()
    };
  }

  println!("Result: {}", result);

  Ok(())
}

fn intersection(set1: &BTreeSet<char>, set2: &BTreeSet<char>) -> BTreeSet<char> {
  let mut result = BTreeSet::new();
  for v in set1.intersection(set2) {
    result.insert(*v);
  }
  result
}