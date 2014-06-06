#include <iostream>

using namespace std

int main()
    
    let x = 0
    
    array <int, 3> arr = {1, 2, 3}
    
    foreach(arr, [&](int a)
        cout << "a: " << a << endl
    )
    
    let go = [](PBYTE buff, int n)
        if (n > 0)
            printf("0x")
            for (let i = 0; i < n; i++)
                printf("%02X", buff[i])
        printf("\n")
    
    unless(false)
        repeat(2)
            until(a > 2)
                x++
                cout << "x: " << x << endl
    
    let sum = [](int a, int b) { return a + b }
    let memoized_sum = memoize(function<int (int, int)>(sum))
    
    cout << memoized_sum(2, 2) << endl
    cout << memoized_sum(2, 2) << endl
    
    return 0
