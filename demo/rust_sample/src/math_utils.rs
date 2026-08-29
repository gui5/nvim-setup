//! Mathematical computation utilities for Rust demo.

/// High performance math calculator.
#[derive(Debug, Clone)]
pub struct Calculator {
    pub name: String,
}

impl Calculator {
    /// Creates a new Calculator instance.
    pub fn new(name: impl Into<String>) -> Self {
        Self { name: name.into() }
    }

    /// Computes the sum of two integers.
    pub fn add(&self, a: i64, b: i64) -> i64 {
        a + b
    }

    /// Computes the product of two integers.
    pub fn multiply(&self, a: i64, b: i64) -> i64 {
        a * b
    }

    /// Computes the first `n` numbers in the Fibonacci sequence.
    pub fn fibonacci(&self, n: usize) -> Vec<u64> {
        if n == 0 {
            return Vec::new();
        }
        if n == 1 {
            return vec![0];
        }
        let mut seq = vec![0, 1];
        while seq.len() < n {
            let next_val = seq[seq.len() - 1] + seq[seq.len() - 2];
            seq.push(next_val);
        }
        seq
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_add() {
        let calc = Calculator::new("Test");
        assert_eq!(calc.add(12, 34), 46);
        assert_eq!(calc.add(-5, 5), 0);
    }

    #[test]
    fn test_multiply() {
        let calc = Calculator::new("Test");
        assert_eq!(calc.multiply(6, 7), 42);
        assert_eq!(calc.multiply(0, 100), 0);
    }

    #[test]
    fn test_fibonacci() {
        let calc = Calculator::new("Test");
        assert_eq!(calc.fibonacci(0), Vec::<u64>::new());
        assert_eq!(calc.fibonacci(1), vec![0]);
        assert_eq!(calc.fibonacci(7), vec![0, 1, 1, 2, 3, 5, 8]);
    }
}
