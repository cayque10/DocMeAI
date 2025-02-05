program DocMeAITest;

uses
  System.StartUpCopy,
  FMX.Forms,
  ConfigurationTest in 'View\ConfigurationTest.pas' {FrmDocMeAIConfigurations},
  DocumentationTest in 'View\DocumentationTest.pas' {FrmDocMeAIDocumentation};

{$R *.res}

begin
{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
{$ENDIF}
  Application.Initialize;
  Application.CreateForm(TFrmDocMeAIConfigurations, FrmDocMeAIConfigurations);
  Application.Run;
end.
