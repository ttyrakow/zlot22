#ifdef __cplusplus
extern "C" {
#endif

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

__declspec(dllexport) char* __cdecl dyn_greet() {
    char *res = (char*) malloc(14);
    strcpy(res, "Hello from C!");
    return res;
}

#ifdef __cplusplus
}
#endif
