#include "lib/Bikini.h"

#include <iostream>
#include <array>

using namespace std

int main()
    
    let x = 666
    
    let pm = match (x)
             [=> 666 => 0
             [=> 111 => 1
             [~>     => 666
    
    cout << "a : " \
         << match ('a')
             [=> 'a' => 0
             [=> 'b' => 1
             [~>     => 666
         
    cout << endl
    
    array <int, 5> Arr = { 0, 1, 2, 3, 4 }
    
    foreach( Arr, [&](int a)
        cout << "a: " << a++ << endl
    )
    
    /* TAB LEN IS 2 HERE, SO IT COULD BE DYNAMIC */
    unless(false)
      repeat(2)
        until(pm > 2)
          pm++
          cout << "pm: " << pm << endl
    
    let go = [](const char* buff, int n)
        if (n > 0)
            printf("0x")
            for (let i = 0; i < n; i++)
                printf("%02X", buff[i])
        printf("\n")
    ;
    
    let buff = "there is let in the string"
    
    let sum = [](int a, int b) { return a + b; }
    let memoized_sum = memoize(function<int (int, int)>(sum))
    
    cout << memoized_sum(2, 2) << endl
    cout << memoized_sum(2, 2) << endl
    
    cout << buff << endl
    go (buff, 4)
    
    [=]() mutable
        x++
        cout << "x [=]:" << x << endl
    ()
    cout << "x:" << x << endl
    
    return 0
