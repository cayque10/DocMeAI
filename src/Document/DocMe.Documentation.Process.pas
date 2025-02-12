unit DocMe.Documentation.Process;

interface

uses
  DocMe.Documentation.Text,
  DocMe.Configurations.Config,
  DocMe.Configurations.Interfaces,
  DocMe.AI.Interfaces,
  DocMe.Documentation.Process.Interfaces,
  DocMe.Documentation.Text.Interfaces;

type

  TDocMeDocumentationProcess = class(TInterfacedObject, IDocMeAIDocumentationProcess)
  private
    FConfig: IDocMeAIConfig;
    FDocMeText: IDocMeAIText;
    FAI: IDocMeAI;
    constructor Create;
  public
    /// <summary>
    /// Creates a new instance of the TDocMeDocumentationProcess class.
    /// </summary>
    class function New: IDocMeAIDocumentationProcess;

    /// <summary>
    /// Destroys the instance of the TDocMeDocumentationProcess class.
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    /// Abstractions the processing flow and may return data related to that processing.
    /// </summary>
    /// <param name="AAdditionalInfo">Optional additional information for processing.</param>
    procedure Process(const AAdditionalInfo: string = '');
  end;

implementation

uses
  System.SysUtils,
  Vcl.Dialogs,
  System.StrUtils,
  DocMe.AI.Factory,
  DocMe.AI.PromptBuilder.Types;

{ TDocMeDocumentationProcess }

constructor TDocMeDocumentationProcess.Create;
begin
  FConfig := TDocMeAIConfig.New.LoadConfig;
  FAI := TDocMeAIFactory.CreateAI(FConfig, pbtDocumentation);
  FDocMeText := TDocMeDocumentationText.New;
end;

destructor TDocMeDocumentationProcess.Destroy;
begin
  inherited;
end;

class function TDocMeDocumentationProcess.New: IDocMeAIDocumentationProcess;
begin
  Result := Self.Create;
end;

procedure TDocMeDocumentationProcess.Process(const AAdditionalInfo: string = '');
var
  lSelectedData: string;
  lProcessedData: string;
begin
  lSelectedData := FDocMeText.GetSelectedText;
  if lSelectedData.Trim.IsEmpty then
  begin
    ShowMessage('No text selected.');
    Exit;
  end;

  lProcessedData := FAI.GenerateSummary(lSelectedData, AAdditionalInfo);
  FDocMeText.ReplaceSelectedText(lProcessedData);
end;

end.
