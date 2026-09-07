"""Unit tests for MathEngine."""

import unittest

from calculator import MathEngine


class TestMathEngine(unittest.TestCase):
    def setUp(self) -> None:
        self.engine = MathEngine()

    def test_add(self) -> None:
        self.assertEqual(self.engine.add(10, 20), 30)
        self.assertEqual(self.engine.add(-5, 5), 0)

    def test_multiply(self) -> None:
        self.assertEqual(self.engine.multiply(6, 7), 42)
        self.assertEqual(self.engine.multiply(0, 100), 0)

    def test_fibonacci(self) -> None:
        self.assertEqual(self.engine.fibonacci(0), [])
        self.assertEqual(self.engine.fibonacci(1), [0])
        self.assertEqual(self.engine.fibonacci(5), [0, 1, 1, 2, 3])


if __name__ == "__main__":
    unittest.main()
