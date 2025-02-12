unit GitTest;

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
  FMX.StdCtrls,
  FMX.ScrollBox,
  FMX.Memo,
  FMX.Controls.Presentation,
  FMX.Objects,
  FMX.Edit,
  DocMe.Configurations.Interfaces,
  FMX.Memo.Types,
  DocMe.AI.Interfaces, FMX.Layouts;

type
  TFrmGitCommentTest = class(TForm)
    RecMem: TRectangle;
    MemDiff: TMemo;
    LbTitle: TLabel;
    LbInfo: TLabel;
    LbSpecification: TLabel;
    MemAdditionalInfo: TMemo;
    LayBottom: TLayout;
    RecBottom: TRectangle;
    BtnGenerate: TRectangle;
    LbGenerate: TLabel;
    BtnCopy: TRectangle;
    LbCopy: TLabel;
    procedure BtnGenerateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnCopyClick(Sender: TObject);
    procedure BtnScaleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure BtnScaleMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
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

    /// <summary>
    /// Sets the specified text to the clipboard.
    /// </summary>
    /// <param name="AText">The text to be copied to the clipboard.</param>
    /// <returns>
    /// Returns True if the text was successfully set to the clipboard; otherwise, False.
    /// </returns>
    function SetTextToClipboard(const AText: string): Boolean;
  public
  end;

implementation

uses
  DocMe.Configurations.Config,
  DocMe.AI.Factory,
  DocMe.AI.PromptBuilder.Types,
  System.Threading,
  DocMe.DiffComment.Process,
  Utils.CustomTask,
  Utils.Forms.Interfaces,
  Utils.Forms.Loading,
  FMX.Clipboard,
  FMX.Platform,
  FMX.Ani;

{$R *.fmx}

procedure TFrmGitCommentTest.BtnCopyClick(Sender: TObject);
begin
  if not SetTextToClipboard(MemDiff.Lines.Text) then
    ShowMessage('Unable to copy text.');
end;

procedure TFrmGitCommentTest.BtnScaleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  TAnimator.AnimateFloat(TControl(Sender), 'Opacity', 0.9, 0.1);
end;

procedure TFrmGitCommentTest.BtnScaleMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  TAnimator.AnimateFloat(TControl(Sender), 'Opacity', 1.0, 0.1);
end;

procedure TFrmGitCommentTest.BtnGenerateClick(Sender: TObject);
var
  lLoading: ILoading;
begin
  DisableControls;
  lLoading := TUtilsFormsLoading.New;

  TCustomThread.Create(True, True).OnRun(
    procedure
    var
      lComment: string;
    begin
      lComment := TDocMeDiffComment.New.Process(MemAdditionalInfo.Lines.Text);

      TThread.Synchronize(nil,
        procedure
        begin
          MemDiff.Lines.Clear;
          MemDiff.Lines.Add(lComment);
        end);
    end).OnStart(
    procedure
    begin
      TThread.Synchronize(nil,
        procedure
        begin
          lLoading.Show(Self, 'Wait. Diff comment in progress.');
        end);
    end).OnFinish(
    procedure
    begin
      TThread.Queue(nil,
        procedure
        begin
          EnableControls;
          lLoading.Hide;
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

procedure TFrmGitCommentTest.DisableControls;
begin
  BtnGenerate.Enabled := False;
  MemDiff.Enabled := False;
end;

procedure TFrmGitCommentTest.EnableControls;
begin
  BtnGenerate.Enabled := True;
  MemDiff.Enabled := True;
end;

procedure TFrmGitCommentTest.FormCreate(Sender: TObject);
begin
  FConfig := TDocMeAIConfig.New.LoadConfig;
  FAI := TDocMeAIFactory.CreateAI(FConfig, pbtDiffComment);
end;

function TFrmGitCommentTest.SetTextToClipboard(const AText: string): Boolean;
var
  LClipboardService: IFMXClipboardService;
begin
  Result := False;
  if TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService, IInterface(LClipboardService)) then
  begin
    LClipboardService.SetClipboard(AText);
    Result := True;
  end;
end;

end.
