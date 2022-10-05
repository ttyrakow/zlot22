unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls;

type
  TFMain = class(TForm)
    Label1: TLabel;
    dirLabel: TLabel;
    selectButton: TButton;
    GroupBox1: TGroupBox;
    filesGrid: TStringGrid;
    calcButton: TButton;
    quitButton: TButton;
    calcLabel: TLabel;
    procedure selectButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure quitButtonClick(Sender: TObject);
    procedure calcButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

uses FileCtrl, IOUtils;

{$R *.dfm}

{$REGION 'Golang constructs'}
type
  GoInt = Int64;
  uintptr_t = NativeInt;
  ptrdiff_t = NativeInt;

  GoString = record
    p: PAnsiChar;   // character array, UTF-8 encoded
    n: ptrdiff_t;   // string length
  end;
  PGoString = ^GoString;

  GoSlice = record
    data: Pointer;  // pointer to data array
    len: GoInt;     // slice length
    cap: GoInt;     // capacity of the underlying array
  end;

function toGoString(const s: string): GoString;
begin
  Result.p := PAnsiChar(UTF8Encode(s));
  Result.n := Length(s);
end;

function fromGoString(const s: GoString): string;
begin
  Result := UTF8ToString(s.p);
end;

{$ENDREGION}

{$REGION 'crc_calc.dll imports'}

// calc SHA-512 of all files, return a handle to a slice of strings inside
function CalcFilesSHA_CGo(paths: GoSlice): uintptr_t; cdecl;
external 'crc_calc.dll' name 'CalcFilesSHA_CGo';

// get the n-th string from the slice the handle is pointing to
function NthString(handle: uintptr_t; n: GoInt): PAnsiChar; cdecl;
external 'crc_calc.dll' name 'NthString';

// free a buffer allocated on the C heap (by C.CString in Go)
procedure C_Free(p: Pointer); cdecl;
external 'crc_calc.dll' name 'C_Free';

// invalidate the handle, GC can now collect the slice
procedure DelHandle(h: uintptr_t); cdecl;
external 'crc_calc.dll' name 'DelHandle';

{$ENDREGION}



procedure TFMain.calcButtonClick(Sender: TObject);
  // make sure goStrs and utf8strs live long enough for the go call to complete
  var
    goStrs: TArray<GoString>;
    utf8strs: TArray<RawByteString>;


  function _packToSlice(const a: TArray<string>): GoSlice;
  begin
    var len := Length(a);

    SetLength(goStrs, len);
    SetLength(utf8strs, len);
    for var i := 0 to len-1 do
    begin
      utf8strs[i] := UTF8Encode(a[i]);
      goStrs[i].p := PAnsiChar(utf8strs[i]);
      goStrs[i].n := Length(utf8strs[i]);
    end;

    Result.data := @goStrs[0];
    Result.len := len;
    Result.cap := len;
  end;

  function _unpackFromSlice(handle: uintptr_t; len: Integer): TArray<string>;
  begin
    SetLength(Result, len);
    for var i := 0 to len-1 do
    begin
      var s: PAnsiChar := NthString(handle, i);
      var rawStr := RawByteString(s);
      Result[i] := UTF8ToString(rawStr);
      C_Free(s); // free go-side
    end;
  end;

begin
  if filesGrid.Cells[0, 1] = '' then
    Exit; // no files

  Enabled := false;
  try
    calcLabel.Visible := true;
    Application.ProcessMessages();

    // 1. store paths in an array
    var paths: TArray<string>;
    SetLength(paths, filesGrid.RowCount - filesGrid.FixedRows);
    for var i := 0 to Length(paths)-1 do
      paths[i] := TPath.Combine(
        dirLabel.Caption, filesGrid.Cells[0, i+filesGrid.FixedRows]);

    // 2. conver the array into a Go slice
    var goPaths := _packToSlice(paths);

    // 3. call the Go routine
    var goSHAsHandle := CalcFilesSHA_CGo(goPaths);

    // 4. convert the resulting slice into an array
    var shas := _unpackFromSlice(goSHAsHandle, Length(paths));

    // 5. invalidate the handle in Go
    DelHandle(goSHAsHandle);

    // 6. present the checksums
    for var i := 0 to Length(shas)-1 do
      if i < filesGrid.RowCount then
        filesGrid.Cells[1, i+filesGrid.FixedRows] := shas[i];
  finally
    Enabled := true;
    calcLabel.Visible := false;
  end;
end;

procedure TFMain.FormCreate(Sender: TObject);
begin
  filesGrid.Cells[0, 0] := 'File name';
  filesGrid.Cells[1, 0] := 'SHA-512 checksum';
end;

procedure TFMain.FormResize(Sender: TObject);
begin
  filesGrid.ColWidths[0] := filesGrid.ClientWidth div 3;
  filesGrid.ColWidths[1] := filesGrid.ClientWidth - filesGrid.ColWidths[0];
end;

procedure TFMain.quitButtonClick(Sender: TObject);
begin
  Application.Terminate();
end;

procedure TFMain.selectButtonClick(Sender: TObject);
begin
  var dir: string := '.';
  if FileCtrl.SelectDirectory(dir, [], 0) then
  begin // the user selected a directory
    dirLabel.Caption := dir;
    var files := TDirectory.GetFiles(dir);
    var rows := 1;
    if length(files) > 1 then
      rows := length(files);
    filesGrid.RowCount := filesGrid.FixedRows + rows;
    var i := filesGrid.FixedRows;
    for var f in files do
    begin // for each file in the directory
      filesGrid.Cells[0, i] := ExtractFileName(f);
      filesGrid.Cells[1, i] := '';
      i := i + 1;
    end; // for each file in the directory
  end; // the user selected a directory
end;

end.
