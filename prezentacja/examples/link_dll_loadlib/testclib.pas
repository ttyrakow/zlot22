program testclib;
{$APPTYPE CONSOLE}

uses Winapi.Windows;

type
    hello_func = function(): PAnsiChar; cdecl;
    c_free_func = procedure(p: Pointer); cdecl;

var
    hello: hello_func;
    c_free: c_free_func;

begin
    var libHandle := LoadLibrary('c_lib.dll');
    hello := hello_func(GetProcAddress(libHandle, 'dyn_greet'));
    c_free := c_free_func(GetProcAddress(libHandle, 'free_c_mem'));

    var c: PAnsiChar := hello();
    writeln(c);
    c_free(c);
    writeln('C memory freed');
    
    FreeLibrary(libHandle);
end.
