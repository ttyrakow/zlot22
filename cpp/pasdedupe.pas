program pasdedupe;
{$APPTYPE CONSOLE}
type
    PInteger = ^Integer;
    PDouble = ^Double;

procedure c_free(p: Pointer); 
cdecl; external 'lib_dedupe.dll' name 'c_free';

procedure dedupe_int(a: PInteger; len: NativeInt;
    out res: PInteger; out res_len: NativeInt); 
cdecl; external 'lib_dedupe.dll' name 'dedupe_int';

procedure dedupe_double(a: PDouble; len: NativeInt;
    out res: PDouble; out res_len: NativeInt); 
cdecl; external 'lib_dedupe.dll' name 'dedupe_double';

procedure dedupe_str(a: PPChar; len: NativeInt;
    out res: PPChar; out res_len: NativeInt); 
cdecl; external 'lib_dedupe.dll' name 'dedupe_str';


procedure print_i(const a: TArray<Integer>);
begin
    write('[');
    for var i in a do write(i,',');
    writeln('] (size: ', Length(a), ')');
end;
procedure print_d(const a: TArray<Double>);
begin
    write('[');
    for var i in a do write(i:0:2,',');
    writeln('] (size: ', Length(a), ')');
end;
procedure print_s(const a: TArray<string>);
begin
    write('[');
    for var i in a do write(i,',');
    writeln('] (size: ', Length(a), ')');
end;


begin
    var v_i: TArray<Integer> := [1, 2, 2, 3, 4, 4, 5, 6, 6, 7];
    var v_d: TArray<Double> := [1.0, 1.5, 1.5, 2.0, 2.5, 2.5, 3.0, 3.5, 3.5, 4.0];
    var v_s: TArray<string> := ['abc', 'abc', 'def', 'def', 'ghi', 'jkl', 'jkl'];

    var len: NativeInt;
    
    var dd_pi: PInteger;
    var dd_i: TArray<Integer>;
    dedupe_int(@v_i[0], Length(v_i), dd_pi, len);
    SetLength(dd_i, len);
    Move(dd_pi^, dd_i[0], len * SizeOf(Integer));
    c_free(dd_pi);

    var dd_pd: PDouble;
    var dd_d: TArray<Double>;
    dedupe_double(@v_d[0], Length(v_d), dd_pd, len);
    SetLength(dd_d, len);
    Move(dd_pd^, dd_d[0], len * SizeOf(Double));
    c_free(dd_pd);

    var v_pc: TArray<PChar>;
    SetLength(v_pc, Length(v_s));
    for var i := 0 to Length(v_s)-1 do
        v_pc[i] := PChar(v_s[i]);

    var dd_pc: PPChar;
    var dd_s: TArray<string>;
    dedupe_str(@v_pc[0], Length(v_pc), dd_pc, len);
    SetLength(dd_s, len);    
    for var i := 0 to len-1 do
    begin
        {$POINTERMATH ON}
        dd_s[i] := dd_pc[i];
        c_free(dd_pc[i]);
    end;
    c_free(dd_pc);

    writeln('int (original):');
    print_i(v_i);
    writeln('int (deduped):');
    print_i(dd_i);
    writeln('double (original):');
    print_d(v_d);
    writeln('double (deduped):');
    print_d(dd_d);
    writeln('string (original):');
    print_s(v_s);
    writeln('string (deduped):');
    print_s(dd_s);
end.