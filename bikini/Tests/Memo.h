#pragma once

#include "../Bikini.h"

#include <iostream>

test_set memo_tests
    std::string("Memoization"), {
        std::make_tuple(
        std::string("Memoization test"),
        std::function<bool()>([]() -> bool
            
            // memoization
            let sum = [](int a, int b) { return a + b; }
            let memoized_sum = memoize(std::function<int (int, int)>(sum));
            
            std::cout << memoized_sum(2, 2) << std::endl
            std::cout << memoized_sum(2, 2) << std::endl
            std::cout << memoized_sum(2, 2) << std::endl
            std::cout << memoized_sum(2, 3) << std::endl
            return memoized_sum(2, 2) == 4
        )) /*;*/
;