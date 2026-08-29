#include <stdio.h>
#include <stdlib.h>

int factorial(int n) {
    if (n <= 1) {
        return 1;
    }
    return n * factorial(n - 1);
}

int main(void) {
    printf("--- C Sample Program ---\n");
    for (int i = 1; i <= 6; ++i) {
        printf("Factorial of %d is %d\n", i, factorial(i));
    }
    return 0;
}
