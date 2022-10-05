unit MainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  System.ImageList, FMX.ImgList, FMX.StdCtrls, FMX.Controls.Presentation,
  FMX.Media, PythonMinimal;

type
  TFMainForm = class(TForm)
    recordButton: TButton;
    transcribeLabel: TLabel;
    ImageList1: TImageList;
    StyleBook1: TStyleBook;
    Timer1: TTimer;
    infoPanel: TCalloutPanel;
    infoLabel: TLabel;
    Timer2: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure recordButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    recording: Boolean;
    mic: TAudioCaptureDevice;

    transcribe_method: PyObject;

    procedure initWhisper();
    procedure info(txt: string);
    procedure transcribe(audio_path: string);


  public
    { Public declarations }
  end;

var
  FMainForm: TFMainForm;

implementation

{$R *.fmx}

uses IOUtils, Math, System.UIConsts;

const
  REC_IMAGES: array[Boolean] of Integer = (0, 1);
  WAV_FILE = 'recorded.wav';
  WHISPER_MODEL = 'small';

{$REGION 'PYTHON_CODE'}
{
  We need to execute in Delphi an equivalent of the following Python code:

  import numpy
  import pytorch
  import whisper
  model = whisper.load_model("small")

  transcription = model.transcribe("recorded.wav")
  result = transcription["text"]

}
{$ENDREGION}

procedure TFMainForm.FormCreate(Sender: TObject);
begin
  transcribe_method := nil;
  recordButton.Enabled := false;
  Timer2.Enabled := true;
end;

procedure TFMainForm.FormDestroy(Sender: TObject);
begin
  if Assigned(transcribe_method) then
    Py_DecRef(transcribe_method);
  Py_Finalize();
end;

procedure TFMainForm.info(txt: string);
begin
  if not infoPanel.Visible then
    infoPanel.Visible := true;
  infoLabel.Text := txt;
  Application.ProcessMessages();
end;

procedure TFMainForm.initWhisper;
begin
  try
  try
    info('Setting FPU exceptions mask compatible with numpy');
    // Super important!
    // Importing numpy / pytorch crash miserably without these
    // FPU masks set - they definitely don't like FPU interrupts
    // on errors, but rather prefer getting NaN back
    Math.SetExceptionMask(
      [exInvalidOp, exDenormalized, exZeroDivide, exOverflow,
      exUnderflow, exPrecision]);

    info('Initializing Python engine');
    Py_Initialize();

    // Either that or generate a console application in Delphi.
    // Whisper won't even let itself be imported without a valid stdout handle.
    // You can also assign nul: as stdout and it's gonna work :)
    info('Redirecting stdout');
    PyRun_SimpleString(PAnsiChar(UTF8Encode(
      'import sys' + #13#10 +
      'f = open("stdout.txt", "w", encoding="utf-8")' + #13#10 +
      'sys.stdout = f' + #13#10 +
      'sys.stderr = f' + #13#10
    )));

    info('Loading NumPy');
    var modNameNP := PyUnicode_FromString('numpy');
    var numpy := PyImport_Import(modNameNP);
    Py_DecRef(modNameNP);
    if numpy = nil then
    begin
      ShowMessage('NumPy package unavailable. Check your Python installation.');
      Exit;
    end;

    info('Loading PyTorch');
    var modNameT := PyUnicode_FromString('torch');
    var torch := PyImport_Import(modNameT);
    Py_DecRef(modNameT);
    if torch = nil then
    begin
      ShowMessage('PyTorch package unavailable. Check your Python installation.');
      Exit;
    end;

    info('Loading Whisper');
    var modNameW := PyUnicode_FromString('whisper');
    var whisper := PyImport_Import(modNameW);
    Py_DecRef(modNameW);

    if whisper = nil then
    begin
      ShowMessage('Whisper package unavailable. Check your Python installation.');
      Exit;
    end;

    info('Loading Whisper language model');
    var load_model := PyObject_GetAttrString(whisper, 'load_model');
    if load_model = nil then
    begin
      ShowMessage('"load_model" function not available in Whisper.');
      Exit;
    end;
    var load_model_params := PyTuple_New(1);
    var model_name := PyUnicode_FromString(WHISPER_MODEL);
    PyTuple_SetItem(load_model_params, 0, model_name);
    var model := PyObject_Call(load_model, load_model_params, nil);
    if model = nil then
    begin
      ShowMessage(
        'Unable to load Whisper language model "' + WHISPER_MODEL + '".');
      Exit;
    end;
    // no Py_DecRef(model_name) 'cause PyTuple_SetItem steals the reference
    Py_DecRef(load_model_params);
    Py_DecRef(load_model);

    info('Obtaining transcription method callable');
    transcribe_method := PyObject_GetAttrString(model, 'transcribe');
    if transcribe_method = nil then
    begin
      ShowMessage('"transcribe" method not available in Whisper model.');
      Exit;
    end;
    recordButton.Enabled := true;
  except
    on e: Exception do
    begin
      ShowMessage('Exception detected: ' + e.Message);
      Exit;
    end;
  end;
  finally
    infoPanel.Visible := false;
  end;
end;

procedure TFMainForm.recordButtonClick(Sender: TObject);
begin
  if
    recording
    and (mic <> nil)
    and (mic.State = TCaptureDeviceState.Capturing)
  then
  begin // stop recording
    mic.StopCapture();
    recording := false;
    Timer1.Enabled := true; // dla pani Gra¿ynki z ksiêgowoœci
  end // stop recording
  else if not recording then
  begin // start recording
    if mic = nil then
    begin
      mic := TCaptureDeviceManager.Current.DefaultAudioCaptureDevice;
      if mic = nil then
      begin
        ShowMessage('Audio capturing device not available!');
        Exit;
      end;
      mic.FileName := WAV_FILE;
    end;
    DeleteFile(WAV_FILE);
    transcribeLabel.Text := '';
    mic.StartCapture();
    recording := true;
  end; // start recording
  recordButton.ImageIndex := REC_IMAGES[recording];
  Application.ProcessMessages();
  if not recording and FileExists(WAV_FILE) then
    transcribe(WAV_FILE);
end;

procedure TFMainForm.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := false;
  var txt := AnsiUpperCase(transcribeLabel.Text);
  if txt.Contains('PRZYGOTUJ') and txt.Contains('DEKLARACJ') then
  begin
    transcribeLabel.TextSettings.FontColor := claRed;
    transcribeLabel.Text :=
      'Tak jest Pani Gra¿ynko. Wszystkim siê zajmê, ju¿ drukujê deklaracjê.';
  end;
end;

procedure TFMainForm.Timer2Timer(Sender: TObject);
begin
  Timer2.Enabled := false;
  initWhisper();
end;

procedure TFMainForm.transcribe(audio_path: string);
begin
  if not Assigned(transcribe_method) then
    Exit;

  try
  try
    info('Transcription in progress');
    var transcribe_params := PyTuple_New(1);
    var sample_path := PyUnicode_FromString(PAnsiChar(UTF8Encode(audio_path)));
    PyTuple_SetItem(transcribe_params, 0, sample_path);

    var transcription :=
      PyObject_Call(transcribe_method, transcribe_params, nil);
    Py_DecRef(transcribe_params);
    // no Py_DecRef(sample_path) 'cause PyTuple_SetItem steals the reference
    if transcription = nil then
      transcribeLabel.Text := '<unsuccessful>'
    else
    begin
      info('Obtaining transcribed text');
      var trans_key := PyUnicode_FromString('text');
      var trans_text := PyDict_GetItem(transcription, trans_key);
      Py_DecRef(trans_key);
      var txt: string := '';
      txt := PyUnicode_AsUTF8(trans_text);
      transcribeLabel.Text := txt;
      // no Py_DecRef on trans_text - PyDict_GetItem returns a borrowed reference
      Py_DecRef(transcription);
      Timer1.Enabled := true; // dla pani Gra¿ynki z ksiêgowoœci :)
    end;
  except
    on e: Exception do
    begin
      ShowMessage('Exception detected: ' + e.Message);
      Exit;
    end;
  end;
  finally
    infoPanel.Visible := false;
  end;
end;

end.
