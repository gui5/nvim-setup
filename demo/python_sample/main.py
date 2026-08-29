#!/usr/bin/env python3
"""Main entry point for Python demo."""

from calculator import MathEngine


def main() -> None:
    engine = MathEngine("Python 3.14 Engine")
    print(f"=== {engine.name} ===")
    print(f"12 + 34 = {engine.add(12, 34)}")
    print(f"12 * 34 = {engine.multiply(12, 34)}")
    print(f"Fibonacci(8) = {engine.fibonacci(8)}")


if __name__ == "__main__":
    main()
