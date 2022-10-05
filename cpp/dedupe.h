#ifndef DEDUPE_H
#define DEDUPE_H

#include <vector>
#include <set>

// the actual implementation of dedupe
template<typename T>
std::vector<T> dedupe(std::vector<T> v) {
    std::set<T> s(v.begin(), v.end());
    return std::vector<T>(s.begin(), s.end());
}

#endif // defined DEDUPE_H
