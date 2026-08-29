#pragma once

#include <cstdint>
#include <string>

namespace math {

class Calculator {
public:
    Calculator() = default;
    ~Calculator() = default;

    int64_t add(int64_t a, int64_t b) const;
    int64_t multiply(int64_t a, int64_t b) const;
    int64_t fibonacci(int64_t n) const;
    std::string describe() const;
};

} // namespace math
