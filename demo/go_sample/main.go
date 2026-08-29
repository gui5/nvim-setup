package main

import (
	"fmt"
)

func main() {
	calc := NewCalculator("Golang Engine")
	fmt.Printf("=== %s ===\n", calc.Name)
	fmt.Printf("12 + 34 = %d\n", calc.Add(12, 34))
	fmt.Printf("12 * 34 = %d\n", calc.Multiply(12, 34))
	fmt.Printf("Fibonacci(8) = %v\n", calc.Fibonacci(8))
}
