#ifdef __cplusplus
extern "C" {
#endif

#include <stdio.h>

__declspec(dllexport) double __cdecl sub_id(int i, double d) {
    printf("Subtracting %f from %d in C\n", d, i);
    double c = i - d;
    return c;
}

__declspec(dllexport) double __cdecl sub_di(double d, int i) {
    printf("Subtracting %d from %f in C\n", i, d);
    double c = d - i;
    return c;
}

#ifdef __cplusplus
}
#endif
