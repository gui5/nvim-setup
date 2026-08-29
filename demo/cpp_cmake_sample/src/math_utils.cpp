#include "math_utils.hpp"
#include <format>
#include <stdexcept>

namespace math {

int64_t Calculator::add(int64_t a, int64_t b) const { return a + b; }

int64_t Calculator::multiply(int64_t a, int64_t b) const { return a * b; }

int64_t Calculator::fibonacci(int64_t n) const {
  if (n < 0) {
    throw std::invalid_argument("Negative index not allowed");
  }
  if (n <= 1) {
    return n;
  }
  int64_t prev = 0;
  int64_t curr = 1;
  for (int64_t i = 2; i <= n; ++i) {
    int64_t next = prev + curr;
    prev = curr;
    curr = next;
  }
  return curr;
}

std::string Calculator::describe() const {
  return "Math Calculator Engine (C++20)";
}

} // namespace math
