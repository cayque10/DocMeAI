unit DocMe.Documentation;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  DocMe.Documentation.Process;

type
  TFrmDocMeDocumentation = class(TForm)
    PnlContainer: TPanel;
    LbSpecification: TLabel;
    MemAdditionalInfo: TMemo;
    PnlButton: TPanel;
    BtnDocument: TButton;
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

implementation

uses
  System.Threading;

{$R *.dfm}

procedure TFrmDocMeDocumentation.BtnDocumentClick(Sender: TObject);
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

procedure TFrmDocMeDocumentation.DisableControls;
begin
  MemAdditionalInfo.Enabled := False;
  BtnDocument.Enabled := False;
end;

procedure TFrmDocMeDocumentation.EnableControls;
begin
  MemAdditionalInfo.Enabled := True;
  BtnDocument.Enabled := True;
end;

end.
