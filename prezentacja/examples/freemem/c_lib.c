#ifdef __cplusplus
extern "C" {
#endif

#include <stdlib.h>
#include <string.h>

__declspec(dllexport) char* __cdecl dyn_greet() {
    char *res = (char*) malloc(14);
    strcpy(res, "Hello from C!");
    return res;
}

__declspec(dllexport) void __cdecl free_c_mem(void* ptr) {
    free(ptr);
}

#ifdef __cplusplus
}
#endif
