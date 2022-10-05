#include <stdlib.h>
#include <stdio.h>

typedef struct {
    unsigned char byte_field;
    int int_field;
    unsigned char byte_field2;
    double double_field;
} c_struct;

__declspec(dllexport) c_struct __cdecl accept_struct(c_struct s) {
    c_struct res;
    
    printf("Got in C:\n");
    printf("byte field: %d\n", s.byte_field);
    printf("int field: %d\n", s.int_field);
    printf("double field: %.2f\n", s.double_field);
    printf("struct size: %zd\n", sizeof(s));
    
    res.byte_field = 2;
    res.int_field = 22;
    res.double_field = 222.22;
    return res;
}





