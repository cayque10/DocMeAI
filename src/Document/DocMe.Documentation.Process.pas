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

  TDocMeDocumentationProcess = class(TInterfacedObject, IDocMeAIProcess)
  private
    FConfig: IDocMeAIConfig;
    FDocMeText: IDocMeAIText;
    FAI: IDocMeAI;
    constructor Create;
  public
    /// <summary>
    /// Creates a new instance of the TDocMeDocumentationProcess class.
    /// </summary>
    class function New: IDocMeAIProcess;

    /// <summary>
    /// Destroys the instance of the TDocMeDocumentationProcess class.
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    /// Processes the documentation with optional additional information.
    /// </summary>
    /// <param name="AAdditionalInfo">
    /// Optional additional information to be used during processing.
    /// </param>
    procedure Process(const AAdditionalInfo: string = '');
  end;

implementation

uses
  System.SysUtils,
  Vcl.Dialogs,
  System.StrUtils,
  DocMe.AI.Factory;

{ TDocMeDocumentationProcess }

constructor TDocMeDocumentationProcess.Create;
begin
  FConfig := TDocMeAIConfig.New.LoadConfig;
  FAI := TDocMeAIFactory.CreateAI(FConfig);
  FDocMeText := TDocMeDocumentationText.New;
end;

destructor TDocMeDocumentationProcess.Destroy;
begin
  inherited;
end;

class function TDocMeDocumentationProcess.New: IDocMeAIProcess;
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

  lProcessedData := FAI.DocumentElements(lSelectedData, AAdditionalInfo);
  FDocMeText.ReplaceSelectedText(lProcessedData);
end;

end.
