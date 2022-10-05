#include<stdlib.h>
#include <vector>
#include <string>
#include "dedupe.h" // the actual implementation of dedupe(...)

extern "C" {
    __declspec(dllexport) void __cdecl c_free(void* p) {
        free(p);
    }

    __declspec(dllexport) void __cdecl dedupe_int(
        int *a, size_t len, int **res, size_t *res_len) {
        std::vector<int> v(a, a+len);
        
        std::vector<int> dd = dedupe(v);
        
        *res = (int*) malloc(dd.size() * sizeof(int));
        for (int i = 0; i < dd.size(); i++) {
            (*res)[i] = dd[i];
        }
        *res_len = dd.size();
    }

    __declspec(dllexport) void __cdecl dedupe_double(
        double *a, size_t len, double **res, size_t *res_len) {
        std::vector<double> v(a, a+len);
        
        std::vector<double> dd = dedupe(v);
        
        *res = (double*) malloc(dd.size() * sizeof(double));
        for (int i = 0; i < dd.size(); i++) {
            (*res)[i] = dd[i];
        }
        *res_len = dd.size();
    }

    __declspec(dllexport) void __cdecl dedupe_str(
        wchar_t **a, size_t len, wchar_t ***res, size_t *res_len) {
        std::vector<std::wstring> v(len);
        for (int i = 0; i < len; i++) {
            v[i] = std::wstring(a[i]);
        }

        std::vector<std::wstring> dd = dedupe(v);
        
        *res = (wchar_t**) malloc(dd.size() * sizeof(wchar_t**));
        for (int i = 0; i < dd.size(); i++) {
            int len = dd[i].length();
            (*res)[i] = (wchar_t*) malloc((len+1) * sizeof(wchar_t));
            dd[i].copy((*res)[i], len);
            (*res)[i][len] = 0;
        }
        *res_len = dd.size();
    }
}


