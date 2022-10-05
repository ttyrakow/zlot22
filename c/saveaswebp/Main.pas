{$A8,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N-,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
{$WARN SYMBOL_DEPRECATED ON}
{$WARN SYMBOL_LIBRARY ON}
{$WARN SYMBOL_PLATFORM ON}
{$WARN SYMBOL_EXPERIMENTAL ON}
{$WARN UNIT_LIBRARY ON}
{$WARN UNIT_PLATFORM ON}
{$WARN UNIT_DEPRECATED ON}
{$WARN UNIT_EXPERIMENTAL ON}
{$WARN HRESULT_COMPAT ON}
{$WARN HIDING_MEMBER ON}
{$WARN HIDDEN_VIRTUAL ON}
{$WARN GARBAGE ON}
{$WARN BOUNDS_ERROR ON}
{$WARN ZERO_NIL_COMPAT ON}
{$WARN STRING_CONST_TRUNCED ON}
{$WARN FOR_LOOP_VAR_VARPAR ON}
{$WARN TYPED_CONST_VARPAR ON}
{$WARN ASG_TO_TYPED_CONST ON}
{$WARN CASE_LABEL_RANGE ON}
{$WARN FOR_VARIABLE ON}
{$WARN CONSTRUCTING_ABSTRACT ON}
{$WARN COMPARISON_FALSE ON}
{$WARN COMPARISON_TRUE ON}
{$WARN COMPARING_SIGNED_UNSIGNED ON}
{$WARN COMBINING_SIGNED_UNSIGNED ON}
{$WARN UNSUPPORTED_CONSTRUCT ON}
{$WARN FILE_OPEN ON}
{$WARN FILE_OPEN_UNITSRC ON}
{$WARN BAD_GLOBAL_SYMBOL ON}
{$WARN DUPLICATE_CTOR_DTOR ON}
{$WARN INVALID_DIRECTIVE ON}
{$WARN PACKAGE_NO_LINK ON}
{$WARN PACKAGED_THREADVAR ON}
{$WARN IMPLICIT_IMPORT ON}
{$WARN HPPEMIT_IGNORED ON}
{$WARN NO_RETVAL ON}
{$WARN USE_BEFORE_DEF ON}
{$WARN FOR_LOOP_VAR_UNDEF ON}
{$WARN UNIT_NAME_MISMATCH ON}
{$WARN NO_CFG_FILE_FOUND ON}
{$WARN IMPLICIT_VARIANTS ON}
{$WARN UNICODE_TO_LOCALE ON}
{$WARN LOCALE_TO_UNICODE ON}
{$WARN IMAGEBASE_MULTIPLE ON}
{$WARN SUSPICIOUS_TYPECAST ON}
{$WARN PRIVATE_PROPACCESSOR ON}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_CAST OFF}
{$WARN OPTION_TRUNCATED ON}
{$WARN WIDECHAR_REDUCED ON}
{$WARN DUPLICATES_IGNORED ON}
{$WARN UNIT_INIT_SEQ ON}
{$WARN LOCAL_PINVOKE ON}
{$WARN MESSAGE_DIRECTIVE ON}
{$WARN TYPEINFO_IMPLICITLY_ADDED ON}
{$WARN RLINK_WARNING ON}
{$WARN IMPLICIT_STRING_CAST ON}
{$WARN IMPLICIT_STRING_CAST_LOSS ON}
{$WARN EXPLICIT_STRING_CAST OFF}
{$WARN EXPLICIT_STRING_CAST_LOSS OFF}
{$WARN CVT_WCHAR_TO_ACHAR ON}
{$WARN CVT_NARROWING_STRING_LOST ON}
{$WARN CVT_ACHAR_TO_WCHAR ON}
{$WARN CVT_WIDENING_STRING_LOST ON}
{$WARN NON_PORTABLE_TYPECAST ON}
{$WARN XML_WHITESPACE_NOT_ALLOWED ON}
{$WARN XML_UNKNOWN_ENTITY ON}
{$WARN XML_INVALID_NAME_START ON}
{$WARN XML_INVALID_NAME ON}
{$WARN XML_EXPECTED_CHARACTER ON}
{$WARN XML_CREF_NO_RESOLVE ON}
{$WARN XML_NO_PARM ON}
{$WARN XML_NO_MATCHING_PARM ON}
{$WARN IMMUTABLE_STRINGS OFF}
unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TFMain = class(TForm)
    openButton: TButton;
    saveButton: TButton;
    quitButton: TButton;
    actions: TActionList;
    open: TAction;
    save: TAction;
    quit: TAction;
    openImageDialog: TOpenDialog;
    saveWebPDialog: TSaveDialog;
    scrollBox: TScrollBox;
    image: TImage;
    Label1: TLabel;
    qualityTrackBar: TTrackBar;
    Label2: TLabel;
    Label3: TLabel;
    encodingLabel: TLabel;
    procedure quitExecute(Sender: TObject);
    procedure saveExecute(Sender: TObject);
    procedure openExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMain: TFMain;

implementation

uses pngimage, jpeg;

{$R *.dfm}

procedure TFMain.FormCreate(Sender: TObject);
begin
  qualityTrackBar.Position :=
    (qualityTrackBar.Max - qualityTrackBar.Min) div 2;
end;

procedure TFMain.openExecute(Sender: TObject);
begin
  if openImageDialog.Execute() then
  begin
    try
      image.Picture.LoadFromFile(openImageDialog.FileName);
    except
      on e: Exception do
        Application.MessageBox(
          PChar('Cannot load picture: ' + e.Message),
          'Error', MB_ICONERROR);
    end;
  end;
end;

procedure TFMain.quitExecute(Sender: TObject);
begin
  Application.Terminate();
end;

{$REGION 'imports from libwebp.dll'}

// void WebPFree(void* ptr);
procedure WebPFree(p: Pointer);
  cdecl; external 'libwebp.dll';

//size_t WebPEncodeRGB(
//  const uint8_t* rgb,
//  int width, int height, int stride,
//  float quality_factor, uint8_t** output);
function WebPEncodeRGB(rgb: PByte; width, height, stride: Integer;
  quality_factor: Single; var output: PByte): NativeUInt;
  cdecl; external 'libwebp.dll';

{$ENDREGION}

procedure TFMain.saveExecute(Sender: TObject);

  function getRGBBuffer(img: TImage): TBytes;
  begin
    var b: TBitmap := TBitmap.Create();
    try
      b.Assign(img.Picture.Graphic);
      SetLength(Result, b.Width * b.Height * 3);
      var ii := 0;
      for var i := 0 to b.Height-1 do
        for var j := 0 to b.Width-1 do
        begin
          var rgb := ColorToRGB(b.Canvas.Pixels[j, i]);
          Result[ii] := Byte(GetRValue(rgb));
          Result[ii+1] := Byte(GetGValue(rgb));
          Result[ii+2] := Byte(GetBValue(rgb));
          ii := ii + 3;
        end;
    finally
      b.Free();
    end;
  end;

begin
  if not saveWebPDialog.Execute() then
    Exit; // early return

  try
    encodingLabel.Visible := true;
    Enabled := false;
    Application.ProcessMessages();

    var rgbBuffer: TBytes := getRGBBuffer(image);
    var webPBuffer: PByte;
    var w := image.Picture.Graphic.Width;
    var h := image.Picture.Graphic.Height;
    var quality: Single := qualityTrackBar.Position;

    var encodedSize :=
      WebPEncodeRGB(@rgbBuffer[0], w, h, 3*w, quality, webPBuffer);

    if encodedSize = 0 then
      raise Exception.Create('Error during WebP image encoding.');
    try
      var f :=
        TFileStream.Create(saveWebPDialog.FileName, fmOpenWrite or fmCreate);
      try
        f.WriteBuffer(webPBuffer[0], encodedSize);
      finally
        f.Free();
      end;
    finally
      Enabled := true;
      encodingLabel.Visible := false;
      if encodedSize > 0 then
        WebPFree(webPBuffer); // allocated inside libwebp
    end;
  except
    on e: Exception do
      Application.MessageBox(
        PChar('Error saving WebP image: ' + e.Message),
        'Error', MB_ICONERROR);
  end;
end;

end.
