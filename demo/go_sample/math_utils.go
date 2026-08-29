package main

// Calculator provides mathematical computation methods.
type Calculator struct {
	Name string
}

// NewCalculator creates a new Calculator instance.
func NewCalculator(name string) *Calculator {
	return &Calculator{Name: name}
}

// Add computes the sum of two integers.
func (c *Calculator) Add(a, b int) int {
	return a + b
}

// Multiply computes the product of two integers.
func (c *Calculator) Multiply(a, b int) int {
	return a * b
}

// Fibonacci returns a slice of the first n Fibonacci numbers.
func (c *Calculator) Fibonacci(n int) []int {
	if n <= 0 {
		return []int{}
	}
	if n == 1 {
		return []int{0}
	}
	res := []int{0, 1}
	for len(res) < n {
		res = append(res, res[len(res)-1]+res[len(res)-2])
	}
	return res
}
