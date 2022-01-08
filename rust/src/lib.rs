use gdnative::prelude::*;
use rand::Rng;

#[derive(NativeClass)]
#[inherit(Node)]
struct GameOfLife {
    cells: Vec<Vec<bool>>,
    size: usize,
}

#[gdnative::methods]
impl GameOfLife {
    fn new(_owner: &Node) -> Self {
        GameOfLife {
            cells: Vec::new(),
            size: 0,
        }
    }

    #[export]
    fn init(&mut self, _owner: &Node, size: usize) {
        self.cells.clear();
        self.cells = vec![vec![false; size]; size];
        self.size = size;
    }

    #[export]
    fn calc(&mut self, _owner: &Node) {
        let mut next = vec![vec![false; self.size]; self.size];
        for y in 0..self.size {
            for x in 0..self.size {
                let mut lives = 0;
                for dy in -1..2 {
                    for dx in -1..2 {
                        if dy == 0 && dx == 0 {
                            continue;
                        }
                        let pos_x = (dx + (x + self.size) as isize) as usize % self.size;
                        let pos_y = (dy + (y + self.size) as isize) as usize % self.size;
                        if self.cells[pos_y][pos_x] {
                            lives += 1;
                        }
                    }
                }
                next[y][x] = lives == 3 || (self.cells[y][x] && lives == 2);
            }
        }
        self.cells = next.clone();
    }

    #[export]
    fn calc_rand(&mut self, _owner: &Node) {
        for y in 0..self.size {
            for x in 0..self.size {
                self.cells[y][x] = rand::thread_rng().gen::<bool>();
            }
        }
    }

    #[export]
    fn get_array(&self, _owner: &Node) -> Vector2Array {
        let mut res = Vector2Array::new();
        for y in 0..self.size {
            for x in 0..self.size {
                if self.cells[y][x] {
                    res.push(Vector2::new(x as f32, y as f32));
                }
            }
        }
        res
    }
}

fn init(handle: InitHandle) {
    handle.add_class::<GameOfLife>();
}

godot_init!(init);
