#include <vector>
#include <iostream>
#include "dedupe.h"

using namespace std;

template<typename T>
void print_vec(const vector<T> &v, ostream& o = cout) {
    o << "[";
    for (auto& itm : v) {
        o << itm << ",";
    }
    o << "] (size: " << v.size() << ")" << endl;
}

void main() {
    vector<int> v_i({1, 2, 2, 3, 4, 4, 5, 6, 6, 7});
    vector<double> v_d({1.0, 1.5, 1.5, 2.0, 2.5, 2.5, 3.0, 3.5, 3.5, 4.0});
    vector<string> v_s({"abc", "abc", "def", "def", "ghi", "jkl", "jkl"});

    vector<int> dd_i = dedupe(v_i);
    vector<double> dd_d = dedupe(v_d);
    vector<string> dd_s = dedupe(v_s);

    cout << "int (original):" << endl;
    print_vec(v_i);
    cout << "int (deduped):" << endl;
    print_vec(dd_i);
    cout << "double (original):" << endl;
    print_vec(v_d);
    cout << "double (deduped):" << endl;
    print_vec(dd_d);
    cout << "string (original):" << endl;
    print_vec(v_s);
    cout << "string (deduped):" << endl;
    print_vec(dd_s);
}

