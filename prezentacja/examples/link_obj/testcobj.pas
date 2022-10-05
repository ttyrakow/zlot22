program testcobj;
{$APPTYPE CONSOLE}

uses System.Win.Crtl;

// math routines not required
const __fltused: Integer = 0;

function hello(): PAnsiChar; cdecl; external name '_dyn_greet';

{$L 'c_obj.obj'}

begin
    var c: PAnsiChar := hello();
    writeln(c);
    free(c); // from System.Win.Crtl
    writeln('C memory freed');
end.
