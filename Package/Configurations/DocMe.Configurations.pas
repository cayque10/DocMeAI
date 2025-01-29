unit DocMe.Configurations;

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
  DocMe.Configurations.Config,
  DocMe.Configurations.Interfaces;

type
  TFrmDocMeConfigurations = class(TForm)
    PnlContainer: TPanel;
    LbSpecification: TLabel;
    PnlButton: TPanel;
    BtnSave: TButton;
    PnlTemperature: TPanel;
    PnlAPIKey: TPanel;
    MemAPIKey: TMemo;
    LbAPIKey: TLabel;
    EdtTemperature: TEdit;
    LbTemperature: TLabel;
    PnlModel: TPanel;
    LbModel: TLabel;
    EdtModel: TEdit;
    PnlMaxToken: TPanel;
    LbMaxToken: TLabel;
    EdtMaxToken: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
  private
    FConfig: IDocMeAIConfig;
    /// <summary>
    /// Saves the current configuration settings to a persistent storage.
    /// </summary>
    procedure SaveConfig;

    /// <summary>
    /// Updates the view with the current configuration settings.
    /// </summary>
    procedure ConfigToView;

    /// <summary>
    /// Validates the data contained in the configuration settings.
    /// </summary>
    procedure ValidateDatas;
  public
  end;

implementation

{$R *.dfm}

procedure TFrmDocMeConfigurations.BtnSaveClick(Sender: TObject);
begin
  SaveConfig;
end;

procedure TFrmDocMeConfigurations.FormCreate(Sender: TObject);
begin
  FConfig := TDocMeAIConfig.New.LoadConfig;
  ConfigToView;
end;

procedure TFrmDocMeConfigurations.ConfigToView;
begin
  MemAPIKey.Lines.Add(FConfig.ApiKey);
  EdtModel.Text := FConfig.ModelAI;
  EdtMaxToken.Text := IntToStr(FConfig.MaxTokens);
  EdtTemperature.Text := FloatToStr(FConfig.Temperature);
end;

procedure TFrmDocMeConfigurations.SaveConfig;
begin
  ValidateDatas;
  FConfig
    .ApiKey(MemAPIKey.Lines.Text.Trim)
    .ModelAI(Trim(EdtModel.Text))
    .MaxTokens(StrToIntDef(EdtMaxToken.Text, MAX_TOKENS_AI))
    .Temperature(StrToFloat(Trim(EdtTemperature.Text)))
    .SaveConfig;

  ShowMessage('Settings saved successfully');
end;

procedure TFrmDocMeConfigurations.ValidateDatas;
var
  lErrorMessage: string;
  lMaxTokens: Integer;
  lTemperature: Double;
  lFormatSettings: TFormatSettings;
  lNormalizeTemperature: string;
begin
  lErrorMessage := '';

  lFormatSettings := TFormatSettings.Create;
  lFormatSettings.DecimalSeparator := '.';

  if MemAPIKey.Lines.Text.Trim.IsEmpty then
    lErrorMessage := lErrorMessage + '- API Key cannot be empty.' + sLineBreak;

  if Trim(EdtModel.Text).IsEmpty then
    lErrorMessage := lErrorMessage + '- Model AI cannot be empty.' + sLineBreak;

  if not TryStrToInt(EdtMaxToken.Text, lMaxTokens) or (lMaxTokens <= 0) then
    lErrorMessage := lErrorMessage + '- Max Tokens must be a valid positive integer.' + sLineBreak;

  lNormalizeTemperature := Trim(EdtTemperature.Text).Replace(',', '.');
  if not TryStrToFloat(lNormalizeTemperature, lTemperature, lFormatSettings) or (lTemperature < 0.0) or
    (lTemperature > 1.0) then
    lErrorMessage := lErrorMessage + '- Temperature must be a valid number between 0.0 and 1.0.' + sLineBreak;

  if not lErrorMessage.IsEmpty then
  begin
    ShowMessage('The following errors were found:' + sLineBreak + lErrorMessage);
    Abort;
  end;
end;

end.
