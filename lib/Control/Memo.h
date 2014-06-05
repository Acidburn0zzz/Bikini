#pragma once

#include <map>

template <typename ReturnType, typename... Args>
std::function<ReturnType (Args...)> memoize(std::function<ReturnType (Args...)> func) {
    std::map<std::tuple<Args...>, ReturnType> cache;
    return ([=](Args... args) mutable {
            std::tuple<Args...> t(args...);
            return cache.find(t) == cache.end()
                ? func(args...)
                : cache[t]; 
    });
}
