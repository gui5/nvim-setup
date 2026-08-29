mod math_utils;

use math_utils::Calculator;

fn main() {
    let calc = Calculator::new("Rust 2021 Engine");
    println!("========================================");
    println!("   {}   ", calc.name);
    println!("========================================");
    println!("Add: 12 + 34 = {}", calc.add(12, 34));
    println!("Multiply: 12 * 34 = {}", calc.multiply(12, 34));
    println!("Fibonacci(10) = {:?}", calc.fibonacci(10));
}
