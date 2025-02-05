unit DocMe.Configurations;

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
  FMX.Edit,
  FMX.Layouts,
  FMX.TabControl,
  FMX.ListBox,
  FMX.Objects,
  DocMe.Configurations.Interfaces;

type
  TFrmDocMeAIConfigurations = class(TForm)
    RecContainer: TRectangle;
    TcAI: TTabControl;
    TiAI: TTabItem;
    LayContainer: TLayout;
    BtnSave: TRectangle;
    LbSave: TLabel;
    RecMaxToken: TRectangle;
    LbMaxToken: TLabel;
    EdtMaxToken: TEdit;
    RecTemperature: TRectangle;
    LbTemperature: TLabel;
    EdtTemperature: TEdit;
    RecAPIKey: TRectangle;
    LbAPIKey: TLabel;
    RecContainerMem: TRectangle;
    MemAPIKey: TMemo;
    RecModel: TRectangle;
    CbModel: TComboBox;
    LbModel: TLabel;
    RecContainerComboAI: TRectangle;
    RecCbAI: TRectangle;
    CbAI: TComboBox;
    LbAI: TLabel;
    RecActive: TRectangle;
    SwActive: TSwitch;
    LbActive: TLabel;
    procedure BtnSaveClick(Sender: TObject);
    procedure CbAIChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SwActiveSwitch(Sender: TObject);
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

    /// <summary>
    /// Retrieves the index of the AI model.
    /// </summary>
    /// <returns>
    /// The index of the AI model as an <see cref="Integer"/>.
    /// </returns>
    function GetIndexAIModel: Integer;

    /// <summary>
    /// Configures the combo box for selecting AI models.
    /// </summary>
    procedure ConfigComboBoxAIModel;
  public
  end;

implementation

uses
  DocMe.Configurations.Config,
  DocMe.AI.ProviderTypes;

{$R *.fmx}
{ TFrmDocMeAISettings }

procedure TFrmDocMeAIConfigurations.BtnSaveClick(Sender: TObject);
begin
  SaveConfig;
end;

procedure TFrmDocMeAIConfigurations.CbAIChange(Sender: TObject);
begin
  FConfig.AIProviderType(TDocMeAIProviderType(CbAI.ItemIndex)).LoadConfig;

  ConfigComboBoxAIModel;
  ConfigToView;
end;

procedure TFrmDocMeAIConfigurations.ConfigToView;
var
  lOnChangeCbAI: TNotifyEvent;
begin
  MemAPIKey.Lines.Clear;
  lOnChangeCbAI := CbAI.OnChange;
  CbAI.OnChange := nil;
  try
    CbAI.ItemIndex := Ord(FConfig.AIProviderType);
  finally
    CbAI.OnChange := lOnChangeCbAI;
  end;
  MemAPIKey.Lines.Add(FConfig.ApiKey);
  CbModel.ItemIndex := GetIndexAIModel;
  EdtMaxToken.Text := IntToStr(FConfig.MaxTokens);
  EdtTemperature.Text := FloatToStr(FConfig.Temperature);
  SwActive.IsChecked := FConfig.Active;
end;

procedure TFrmDocMeAIConfigurations.FormCreate(Sender: TObject);
begin
  TcAI.TabPosition := TTabPosition.None;
  FConfig := TDocMeAIConfig.New.LoadConfig;
  ConfigComboBoxAIModel;
  ConfigToView;
end;

function TFrmDocMeAIConfigurations.GetIndexAIModel: Integer;
var
  I: Integer;
begin
  Result := 0;

  CbModel.BeginUpdate;
  try
    for I := 0 to Pred(CbModel.Count) do
    begin
      if CbModel.ListItems[I].Text.ToLower = FConfig.ModelAI.ToLower then
      begin
        Result := I;
        Break;
      end;
    end;
  finally
    CbModel.EndUpdate;
  end;
end;

procedure TFrmDocMeAIConfigurations.ConfigComboBoxAIModel;
var
  lSelectedType: string;
  lModels: TArray<string>;
  I: Integer;
begin
  lSelectedType := FConfig.AIProviderTypeName;
  CbModel.Clear;

  if FConfig.AIModelsProvider.GetAIModelsList.TryGetValue(lSelectedType, lModels) then
  begin
    for I := Low(lModels) to High(lModels) do
      CbModel.Items.Add(lModels[I]);
    if CbModel.Items.Count > 0 then
      CbModel.ItemIndex := 0;
  end;
end;

procedure TFrmDocMeAIConfigurations.SaveConfig;
begin
  ValidateDatas;

  FConfig
    .AIProviderType(TDocMeAIProviderType(CbAI.ItemIndex))
    .ApiKey(MemAPIKey.Lines.Text.Trim)
    .ModelAI(Trim(CbModel.Items[CbModel.ItemIndex]))
    .MaxTokens(StrToIntDef(EdtMaxToken.Text, MAX_TOKENS_AI))
    .Temperature(StrToFloat(Trim(EdtTemperature.Text)))
    .SaveConfig;

  ShowMessage('Settings saved successfully');
end;

procedure TFrmDocMeAIConfigurations.SwActiveSwitch(Sender: TObject);
begin
  FConfig.Active(SwActive.IsChecked);
end;

procedure TFrmDocMeAIConfigurations.ValidateDatas;
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

  if Trim(CbModel.Items[CbModel.ItemIndex]).IsEmpty then
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
