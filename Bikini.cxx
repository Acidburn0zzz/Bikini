#include <iostream>

int main()
    let x = 0
    let go = [](PBYTE buff, int n)
        if (n > 0)
            printf("0x")
            for (let i = 0; i < n; i++)
                printf("%02X", buff[i])
        printf("\n")
    std::cout << "Hello World!" << std::endl
    return x
