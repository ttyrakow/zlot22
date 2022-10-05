#include <stdlib.h>

__declspec(dllexport) double __cdecl cpp_sum_cdecl(double *a, unsigned len) {
    return 0.0;
}

__declspec(dllexport) double __stdcall cpp_sum_stdcall(double *a, unsigned len) {
    return 0.0;
}

__declspec(dllexport) double __fastcall cpp_sum_fastcall(double *a, unsigned len) {
    return 0.0;
}

__declspec(dllexport) double __vectorcall cpp_sum_vectorcall(double *a, unsigned len) {
    return 0.0;
}

extern "C" {
    __declspec(dllexport) double __cdecl c_sum_cdecl(double *a, unsigned len) {
        return 0.0;
    }
    __declspec(dllexport) double __stdcall c_sum_stdcall(double *a, unsigned len) {
        return 0.0;
    }
    __declspec(dllexport) double __fastcall c_sum_fastcall(double *a, unsigned len) {
        return 0.0;
    }
    __declspec(dllexport) double __vectorcall c_sum_vectorcall(double *a, unsigned len) {
        return 0.0;
    }
}
