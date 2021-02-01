mod intcode;
use intcode::{Intcode, read_program};
use std::cell::{RefCell, RefMut};
use std::rc::Rc;

fn main() -> std::io::Result<()> {
  let program: Vec<i64> = read_program("23/input");

  let mut networked_intcodes = vec![];
  let mut output_from_networked_intcodes: Vec<Vec<i64>> = vec![];
  for i in 0..50 {
    networked_intcodes.push(NetworkedIntcode::new(i, &program));
    output_from_networked_intcodes.push(vec![]);
  }

  loop {
    for i in 0..50 {
      let networked_intcode = &mut networked_intcodes[i];
      let output_from_networked_intcode = &mut output_from_networked_intcodes[i];
      match networked_intcode.run() {
        None => (),
        Some(value) => {
          output_from_networked_intcode.push(value);
        }
      };
      if output_from_networked_intcode.len() == 3 {
        let destination = output_from_networked_intcode.remove(0);
        let x = output_from_networked_intcode.remove(0);
        let y = output_from_networked_intcode.remove(0);

        println!("Sending {},{} to {}", x, y, destination);
        if destination == 255 {
          return Ok(());
        }

        networked_intcodes[destination as usize].receive_packet(x, y);
      }
    }
  }
}

struct NetworkedIntcode {
  intcode: Intcode,
  packets: Rc<RefCell<Vec<i64>>>,
}

impl NetworkedIntcode {
  fn new<'a>(network_address: i64, program: &'a Vec<i64>) -> NetworkedIntcode {
    let packets = Rc::new(RefCell::new(Vec::new()));
    let network_iter = NetworkIter::new(network_address, packets.clone());
    let intcode = Intcode::new(&program, Box::new(network_iter));
    NetworkedIntcode {
      intcode,
      packets,
    }
  }

  fn run(&mut self) -> Option<i64> {
    self.intcode.run()
  }

  fn receive_packet(&mut self, x: i64, y: i64) {
    let mut packets_vec: RefMut<_> = self.packets.borrow_mut();
    packets_vec.push(x);
    packets_vec.push(y);
  }
}

struct NetworkIter {
  packets: Rc<RefCell<Vec<i64>>>,
}

impl NetworkIter {
  fn new(network_address: i64, packets: Rc<RefCell<Vec<i64>>>) -> NetworkIter {
    {
      let mut packets_vec: RefMut<_> = packets.borrow_mut();
      packets_vec.push(network_address);
    }
    NetworkIter {
      packets,
    }
  }
}

impl Iterator for NetworkIter {
  type Item = i64;

  fn next(&mut self) -> Option<i64> {
    let mut packets_vec: RefMut<_> = self.packets.borrow_mut();
    if packets_vec.len() > 0 {
      Some(packets_vec.remove(0))
    } else {
      Some(-1)
    }
  }
}