program teststruct;
{$APPTYPE CONSOLE}

type c_struct = record
    b_field: Byte;
    i_field: Integer;
    b_field2: Byte;
    d_field: Double;
end;

function c_accept_struct(s: c_struct): c_struct; cdecl;
external 'libstruct.dll' name 'accept_struct';

begin
    var s: c_struct;
    s.b_field := 1;
    s.i_field := 11;
    s.d_field := 111.11;
    var t: c_struct := c_accept_struct(s);
    writeln('');
    writeln('Returned from C:');
    writeln('b_field: ', t.b_field);
    writeln('i_field: ', t.i_field);
    writeln('d_field: ', t.d_field:0:2);
    writeln('struct size: ', SizeOf(t));
end.




