package main

import (
	"reflect"
	"testing"
)

func TestAdd(t *testing.T) {
	calc := NewCalculator("TestCalc")
	got := calc.Add(15, 27)
	want := 42
	if got != want {
		t.Errorf("Add(15, 27) = %d; want %d", got, want)
	}
}

func TestMultiply(t *testing.T) {
	calc := NewCalculator("TestCalc")
	got := calc.Multiply(6, 7)
	want := 42
	if got != want {
		t.Errorf("Multiply(6, 7) = %d; want %d", got, want)
	}
}

func TestFibonacci(t *testing.T) {
	calc := NewCalculator("TestCalc")
	got := calc.Fibonacci(6)
	want := []int{0, 1, 1, 2, 3, 5}
	if !reflect.DeepEqual(got, want) {
		t.Errorf("Fibonacci(6) = %v; want %v", got, want)
	}
}
