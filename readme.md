Bikini
------

[![Build Status](https://travis-ci.org/Heather/Bikini.png?branch=master)](https://travis-ci.org/Heather/Bikini)

Current state
=============

``` cpp
#include "lib/Bikini.h"

#include <iostream>
#include <array>

using namespace std

int main()
    
    let x = 666
    
    /* Experimental syntax, Don't use it ! */
    let pm = match (x)
             [=> 666 => 0
             [=> 111 => 1
             [~>     => 666
    
    array <int, 3> arr = {1, 2, 3}
    
    foreach(arr, [&](int a)
        cout << "a: " << a << endl
    )
    
    let go = [](const char* buff, int n)
        if (n > 0)
            printf("0x")
            for (let i = 0; i < n; i++)
                printf("%02X", buff[i])
        printf("\n")
    
    let buff = "there is let in the string"
    
    /* TAB LEN IS 2 HERE, SO IT COULD BE DYNAMIC */
    unless(false)
      repeat(2)
        until(pm > 2)
          pm++
          cout << "pm: " << pm << endl
    
    let sum = [](int a, int b) { return a + b; }
    let memoized_sum = memoize(function<int (int, int)>(sum))
    
    cout << memoized_sum(2, 2) << endl
    cout << memoized_sum(2, 2) << endl
    
    cout << buff << endl
    go (buff, 4)
    
    return 0
```

Tests
-----

``` shell
Bikini>test.cmd
building Prelude...
Running Prelude tests...
Running test set 'Basics'...
x: 1
x: 2
x: 3
a: 0
a: 1
a: 2
1/1 passed
Running test set 'Memoization'...
4
4
4
5
1/1 passed
building Test application...

Compiling...
Tests:
a: 1
a: 2
a: 3
pm: 1
pm: 2
pm: 3
4
4
there is let in the string
0x74686572
Cleaning...
```








