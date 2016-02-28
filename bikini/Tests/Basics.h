#pragma once

#include "../Bikini.h"

#include <iostream>
#include <array>

test_set basics_tests
    std::string("Basics"), {
        std::make_tuple(
        std::string("Basics test"),
        std::function<bool()>([]() -> bool
            a <- 0
            unless(false)
                repeat(2)
                    until(a > 2)
                        std::cout << "a: " << a << std::endl
                        a++
            <!>
            return a == 3
        )) <!>
;
