program testclib;
{$APPTYPE CONSOLE}

// math routines not required
const __fltused: Integer = 0;

function hello(): PAnsiChar; cdecl; 
external 'c_lib.dll' name 'dyn_greet';

procedure c_free(p: Pointer); cdecl;
external 'c_lib.dll' name 'free_c_mem';

begin
    var c: PAnsiChar := hello();
    writeln(c);
    c_free(c);
    writeln('C memory freed');
end.
