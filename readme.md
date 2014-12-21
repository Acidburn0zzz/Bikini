Bikini
------

[![Build Status](https://travis-ci.org/Heather/Bikini.png?branch=master)](https://travis-ci.org/Heather/Bikini)

Current state
=============

``` cpp
#include "../../lib/Bikini.h"
#include "test.hpp"

#include <iostream>
#include <array>

using namespace std

int main()
    
    xxx <- 666
    
    // TODO: use <- and match syntax in the same codeline
    // right recursion: parse & analyse value first
    auto pm = match (xxx)
             [=> 666 => 0
             [=> 111 => 1
             [~>     => 666
    ;
    cout << "a : " \
         << match ('a')
             [=> 'a' => 0
             [=> 'b' => 1
             [~>     => 666
         << endl;
    
    array <int, 5> Arr = { 0, 1, 2, 3, 4 }
    
    foreach( Arr, [&](int a)
        cout << "foreach a: " << a++ << endl
    )
    for( int a : Arr ) cout << "for a: " << a++ << endl
    
    /* TAB LEN IS 2 HERE, SO IT COULD BE DYNAMIC */
    unless(false)
      repeat(2)
        until(pm > 2)
          pm++
          cout << "pm: " << pm << endl
    
    let go = [](const char* buff, int n)
        if (n > 0)
            printf("0x")
            for (auto i = 0; i < n; i++)
                printf("%02X", buff[i])
        printf("\n")
    ;
    
    let buff = "there is let in the string"
    
    foo()
    
    cout << buff << endl
    go (buff, 4)
    
    [=]() mutable
        xxx++
        cout << "xxx [=]:" << xxx << endl
    ()
    cout << "xxx:" << xxx << endl
    
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

Projects used:
--------------

 - GC: https://github.com/axilmar/cppgc
 - C++ Quickcheck
 - Idris: https://github.com/idris-lang/Idris-dev
 - ...
