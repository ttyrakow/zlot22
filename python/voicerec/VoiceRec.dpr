program VoiceRec;

uses
  System.StartUpCopy,
  FMX.Forms,
  MainForm in 'MainForm.pas' {FMainForm},
  PythonMinimal in 'PythonMinimal.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMainForm, FMainForm);
  Application.Run;
end.
