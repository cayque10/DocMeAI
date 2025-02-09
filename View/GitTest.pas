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
  DocMe.AI.Interfaces;

type
  TFrmGitCommentTest = class(TForm)
    RecMem: TRectangle;
    MemDiff: TMemo;
    BtnGenerate: TRectangle;
    LbGenerate: TLabel;
    LbTitle: TLabel;
    procedure BtnGenerateClick(Sender: TObject);
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

implementation

uses
  DocMe.Configurations.Config,
  DocMe.AI.Factory,
  DocMe.AI.PromptBuilder.Types,
  System.Threading,
  DocMe.DiffComment.Process,
  Utils.CustomTask,
  Utils.Forms.Interfaces,
  Utils.Forms.Loading;

{$R *.fmx}

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
      lComment := TDocMeDiffComment.New.Process;

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

end.
