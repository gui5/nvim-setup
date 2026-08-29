#include "banner.hpp"
#include "math_utils.hpp"
#include <iostream>
#include <print>

int main() {

  print_banner("Neovim C++26 CMake Sample Project");

  math::Calculator calc;
  std::cout << "Engine: " << calc.describe() << "\n";

  int64_t a = 12;
  int64_t b = 34;

  std::println("Add: {} + {} = {}", a, b, calc.add(a, b));
  std::println("Multiply: {} * {} = {}", a, b, calc.multiply(a, b));

  std::cout << "Fibonacci sequence:\n";
  for (int64_t i = 0; i <= 10; ++i) {
    std::println("F({}) = {}", i, calc.fibonacci(i));
  }

  return 0;
}
