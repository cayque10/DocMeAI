program DocMeAITest;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'View\Main.pas' {FrmDocMeAITest};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmDocMeAITest, FrmDocMeAITest);
  Application.Run;
end.
