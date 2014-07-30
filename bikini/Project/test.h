#include "lib/Bikini.h"

#include <iostream>
#include <array>

using namespace std

void foo()
    let sum = [](int a, int b) { return a + b; }
    let memoized_sum = memoize(function<int (int, int)>(sum))
    
    cout << memoized_sum(2, 2) << endl
    cout << memoized_sum(2, 2) << endl
