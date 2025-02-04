unit DocumentationTest;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Memo.Types,
  FMX.ScrollBox,
  FMX.Memo,
  FMX.Objects,
  DocMe.Configurations.Interfaces,
  DocMe.AI.Interfaces;

type
  TFrmDocMeAIDocumentation = class(TForm)
    LbSpecification: TLabel;
    MemAdditionalInfo: TMemo;
    RecButton: TRectangle;
    RecContainer: TRectangle;
    BtnDocument: TRectangle;
    LbDocument: TLabel;
    procedure BtnDocumentClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FConfig: IDocMeAIConfig;
    FAI: IDocMeAI;
    /// <summary>
    /// Disables the visual controls.
    /// </summary>
    procedure DisableControls;

    /// <summary>
    /// Enables the visual controls.
    /// </summary>
    procedure EnableControls;
  public
  end;

var
  FrmDocMeAIDocumentation: TFrmDocMeAIDocumentation;

implementation

uses
  System.Threading,
  DocMe.Configurations.Config,
  DocMe.AI.Factory;

{$R *.fmx}
{ TFrmDocMeAIDocumentation }

procedure TFrmDocMeAIDocumentation.BtnDocumentClick(Sender: TObject);
begin
  DisableControls;

  // TDocMeDocumentationProcess.New.Process(MemAdditionalInfo.Lines.Text.Trim);
  try
   ShowMessage(FAI.DocumentElements(MemAdditionalInfo.Lines.Text.Trim));

  finally
    EnableControls;
  end;

end;

procedure TFrmDocMeAIDocumentation.DisableControls;
begin
  MemAdditionalInfo.Enabled := False;
  BtnDocument.Enabled := False;
end;

procedure TFrmDocMeAIDocumentation.EnableControls;
begin
  MemAdditionalInfo.Enabled := True;
  BtnDocument.Enabled := True;
end;

procedure TFrmDocMeAIDocumentation.FormCreate(Sender: TObject);
begin
  FConfig := TDocMeAIConfig.New.LoadConfig;
  FAI := TDocMeAIFactory.CreateAI(FConfig);
end;

end.
