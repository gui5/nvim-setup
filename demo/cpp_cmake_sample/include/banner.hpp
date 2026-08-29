#pragma once

#include <print>
#include <string>
#include <string_view>

struct Banner {
  std::string title;
  std::size_t width = 40;

  void print() const {
    auto const line = std::string(width, '=');

    std::println("{}", line);
    std::println("{:^{}}", title, width);
    std::println("{}", line);
    std::println("");
  }
};

void print_banner(std::string_view title) {
  auto const banner = Banner{.title = std::string(title)};
  banner.print();
}
