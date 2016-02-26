#pragma once

#include <iostream>

/* FROM FTL */
using test_t = std::tuple<std::string,std::function<bool()>>
using test_set = std::tuple<std::string,std::vector<test_t>>
bool run_test_set(test_set& ts, std::ostream& os)
    os << "Running test set '" << std::get<0>(ts) << "'...\n"
    nsuc  <- 0
    nfail <- 0
    //
    for(const auto& t : std::get<1>(ts))
        try
            if(!std::get<1>(t)())
                if(nfail == 0) { os << std::endl; }
                os << std::get<0>(t) \
                   << ": fail" << std::endl;
                ++nfail
            else ++nsuc
        //
        catch(...)
            os  << "Unexpected exception raised while running '" \
                << std::get<0>(t) << "'" << std::endl;
            throw
    //
    os << nsuc << "/" \
       << std::get<1>(ts).size() \
       << " passed" << std::endl;
    return nfail == 0
