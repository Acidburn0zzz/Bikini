[![Build Status](https://travis-ci.org/Heather/Bikini.png?branch=master)](https://travis-ci.org/Heather/Bikini)

in current state you should know how it works to use it... and it's terrible

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
    tst <- match (xxx)
             [=> 666 => 0
             [=> 111 => 1
             [~>     => 666
    ; /* Because I need to close lambda in init <- */
    
    cout << "a : " \
         << match ('a')
             [=> 'a' => 0
             [=> 'b' => 1
             [~>     => 666
         << endl;
    /* end; because I don't need to close expression in cout */
    
    array <int, 5> Arr = { 0, 1, 2, 3, 4 }
    /* iteration example with foreach and lambda */
    foreach ( Arr, [&] (int a)
        cout << "foreach a: " << a++ << endl
    )
    /* iteration example with modern for */
    for ( int a : Arr ) cout << "for a: " << a++ << endl
    /* iteration example with foreach and declared lambda */
    let myFunctor = [](int a)
        cout << "foreach with functor a: " << a++ << endl
    ; /* as well there is init with lambda so ; must be here */
    foreach ( Arr, myFunctor )
    
    /* TAB LEN IS 2 HERE, SO IT COULD BE DYNAMIC */
    unless (false)
      repeat (2)
        until (tst > 2)
          tst++
          cout << "tst: " << tst << endl
    
    /* yet another lambda with arguments */
    let go = [](const char* buff, int n)
        if (n > 0)
            printf ("0x")
            for (auto i = 0; i < n; i++)
                printf ("%02X", buff[i])
        printf ("\n")
    ;
    
    /* Bikini keywords shouldn't break strings */
    let buff = "there is let in the string"
    /* Calling method from header file */
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

<img align="left" src="http://fc06.deviantart.net/fs71/f/2014/106/0/b/anime_render_16_by_cheshire_pops-d7eoifz.png"/>
