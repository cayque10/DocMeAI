unit DocMe.Documentation;

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
  FMX.Objects;

type
  TFrmDocMeAIDocumentation = class(TForm)
    LbSpecification: TLabel;
    MemAdditionalInfo: TMemo;
    RecButton: TRectangle;
    RecContainer: TRectangle;
    BtnDocument: TRectangle;
    LbDocument: TLabel;
    procedure BtnDocumentClick(Sender: TObject);
  private
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
  DocMe.Documentation.Process;

{$R *.fmx}
{ TFrmDocMeAIDocumentation }

procedure TFrmDocMeAIDocumentation.BtnDocumentClick(Sender: TObject);
begin
  DisableControls;

  TTask.Run(
    procedure
    begin
      try
        TDocMeDocumentationProcess.New.Process(MemAdditionalInfo.Lines.Text.Trim);

        TThread.Synchronize(nil,
          procedure
          begin
            Self.Close;
          end);
      except
        on E: Exception do
        begin
          TThread.Synchronize(nil,
            procedure
            begin
              EnableControls;
              ShowMessage('An error occurred: ' + E.Message);
            end);
        end;
      end;
    end);
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

end.
