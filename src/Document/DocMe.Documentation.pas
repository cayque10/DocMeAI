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
    procedure BtnScaleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure BtnScaleMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
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

implementation

uses
  System.Threading,
  DocMe.Documentation.Process,
  Utils.CustomTask,
  Utils.Forms.Interfaces,
  Utils.Forms.Loading,
  FMX.Ani;

{$R *.fmx}
{ TFrmDocMeAIDocumentation }

procedure TFrmDocMeAIDocumentation.BtnDocumentClick(Sender: TObject);
var
  lLoading: ILoading;
begin
  DisableControls;
  lLoading := TUtilsFormsLoading.New;

  TCustomThread.Create(True, True).OnRun(
    procedure
    begin
      TDocMeDocumentationProcess.New.Process(MemAdditionalInfo.Lines.Text.Trim);
    end).OnStart(
    procedure
    begin
      TThread.Synchronize(nil,
        procedure
        begin
          lLoading.Show(Self, 'Wait. Documentation in progress.');
        end);
    end).OnFinish(
    procedure
    begin
      TThread.Queue(nil,
        procedure
        begin
          EnableControls;
          lLoading.Hide;
          Self.Close;
        end);
    end).OnError(
    procedure(AErrorMsg: String)
    begin
      TThread.Queue(nil,
        procedure
        begin
          EnableControls;
          lLoading.Hide;
          ShowMessage(AErrorMsg);
        end);
    end).Start;
end;

procedure TFrmDocMeAIDocumentation.BtnScaleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Single);
begin
  TAnimator.AnimateFloat(TControl(Sender), 'Opacity', 0.9, 0.1);
end;

procedure TFrmDocMeAIDocumentation.BtnScaleMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Single);
begin
  TAnimator.AnimateFloat(TControl(Sender), 'Opacity', 1.0, 0.1);
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
