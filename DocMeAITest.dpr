program DocMeAITest;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'View\Main.pas' {FrmDocMeAISettings},
  DocumentationTest in 'View\DocumentationTest.pas' {FrmDocMeAIDocumentation};

{$R *.res}

begin
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}
  Application.Initialize;
  Application.CreateForm(TFrmDocMeAISettings, FrmDocMeAISettings);
  Application.Run;
end.
