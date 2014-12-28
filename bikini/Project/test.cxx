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
