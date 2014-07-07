#pragma once

#include "../Bikini.h"

#include <iostream>
#include <array>

test_set basics_tests
    std::string("Basics"), {
        std::make_tuple(
        std::string("Basics test"),
        std::function<bool()>([]() -> bool
            let a = 0
            std::array<int, 3> arr = {1, 2, 3}
            foreach(arr, [&](int x)
                std::cout << "x: " << x << std::endl
            )
            
            unless(false)
                repeat(2)
                    until(a > 2)
                        std::cout << "a: " << a << std::endl
                        a++
            
            return a == 3
        )) /*;*/
;