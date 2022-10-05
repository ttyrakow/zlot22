program sub_wrong_types;
{$APPTYPE CONSOLE}

function sub_di(d: Double; i: Integer): Double; cdecl; 
    external 'lib_sub.dll' name 'sub_id';

function sub_id(i: Integer; d: Double): Double; cdecl; 
    external 'lib_sub.dll' name 'sub_di';

begin
    writeln('11.5 - 5 = ', sub_di(11.5, 5));
    writeln('11 - 5.5 = ', sub_id(11, 5.5));
end.
