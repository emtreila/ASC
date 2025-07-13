#include <stdio.h>

int binaryToOctal(int binary);

int main() {
    int binary, octal;

    printf("Enter a binary number: ");
    scanf("%d", &binary);

    octal = binaryToOctal(binary);

    printf("Octal: %o\n", octal); 

    return 0;
}
