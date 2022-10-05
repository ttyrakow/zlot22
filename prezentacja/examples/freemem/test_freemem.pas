program testclib;
{$APPTYPE CONSOLE}

function hello(): PAnsiChar; cdecl; 
external 'c_lib.dll' name 'dyn_greet';

procedure c_free(p: Pointer); cdecl;
external 'c_lib.dll' name 'free_c_mem';

begin
    var c: PAnsiChar := hello();
    writeln(c);
    FreeMem(c); // Runtime error 204 - invalid pointer operation
    writeln('C memory freed');
end.
