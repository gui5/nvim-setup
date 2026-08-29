"""Math calculation utilities with type annotations and docstrings."""

from typing import List


class MathEngine:
    """A clean mathematical computation engine."""

    def __init__(self, name: str = "PyCalc") -> None:
        self.name: str = name

    def add(self, a: float, b: float) -> float:
        """Return the sum of two numbers."""
        return a + b

    def multiply(self, a: float, b: float) -> float:
        """Return the product of two numbers."""
        return a * b

    def fibonacci(self, n: int) -> List[int]:
        """Compute the first n Fibonacci numbers."""
        if n <= 0:
            return []
        if n == 1:
            return [0]
        sequence: List[int] = [0, 1]
        while len(sequence) < n:
            sequence.append(sequence[-1] + sequence[-2])
        return sequence
