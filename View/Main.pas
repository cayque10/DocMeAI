unit Main;

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
  DocMe.Configurations.Interfaces,
  System.Generics.Collections;

type
  TFrmDocMeAISettings = class(TForm)
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
    RecModelTitle: TRectangle;
    LbModel: TLabel;
    RecContainerComboAI: TRectangle;
    CbAI: TComboBox;
    SwActive: TSwitch;
    BtnDocument: TButton;
    procedure BtnSaveClick(Sender: TObject);
    procedure CbAIChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnDocumentClick(Sender: TObject);
    procedure SwActiveSwitch(Sender: TObject);
  private
    FConfig: IDocMeAIConfig;
    FAIModels: TDictionary<string, TArray<string>>;
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
    function GetIndexAIModel: Integer;
    procedure ConfigComboBoxAIModel;
    procedure GenerateAIModels;
  public
  end;

var
  FrmDocMeAISettings: TFrmDocMeAISettings;

implementation

uses
  DocMe.Configurations.Config,
  DocMe.AI.ProviderTypes,
  DocumentationTest;

{$R *.fmx}
{ TFrmDocMeAISettings }

procedure TFrmDocMeAISettings.BtnDocumentClick(Sender: TObject);
var
  lDocument: TFrmDocMeAIDocumentation;
begin

  lDocument := TFrmDocMeAIDocumentation.Create(nil);
  try
    lDocument.ShowModal;
  finally
    lDocument.Free;
  end;
end;

procedure TFrmDocMeAISettings.BtnSaveClick(Sender: TObject);
begin
  SaveConfig;
end;

procedure TFrmDocMeAISettings.CbAIChange(Sender: TObject);
begin
  FConfig.AIProviderType(TDocMeAIProviderType(CbAI.ItemIndex)).LoadConfig;

  ConfigComboBoxAIModel;
  ConfigToView;
end;

procedure TFrmDocMeAISettings.ConfigToView;
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

procedure TFrmDocMeAISettings.FormCreate(Sender: TObject);
begin
  TcAI.TabPosition := TTabPosition.None;
  GenerateAIModels;
  FConfig := TDocMeAIConfig.New.LoadConfig;
  ConfigComboBoxAIModel;
  ConfigToView;
end;

procedure TFrmDocMeAISettings.FormDestroy(Sender: TObject);
begin
  FAIModels.Free;
end;

function TFrmDocMeAISettings.GetIndexAIModel: Integer;
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

procedure TFrmDocMeAISettings.ConfigComboBoxAIModel;
var
  lSelectedType: string;
  lModels: TArray<string>;
  I: Integer;
begin
  lSelectedType := FConfig.AIProviderTypeName;
  CbModel.Clear;

  if FAIModels.TryGetValue(lSelectedType, lModels) then
  begin
    for I := Low(lModels) to High(lModels) do
      CbModel.Items.Add(lModels[I]);
    if CbModel.Items.Count > 0 then
      CbModel.ItemIndex := 0;
  end;
end;

procedure TFrmDocMeAISettings.GenerateAIModels;
begin
  FAIModels := TDictionary < string, TArray < string >>.Create;
  FAIModels.Add('ChatGPT', ['gpt-4o', 'gpt-4o-mini', 'o1', 'o1-mini', 'o3-mini']);
  FAIModels.Add('Gemini', ['gemini-1.5-flash', 'gemini-1.5-flash-8b', 'gemini-1.5-pro', 'gemini-2.0-flash-exp']);
  FAIModels.Add('DeepSeek', ['deepseek-chat', 'deepseek-reasoner']);
end;

procedure TFrmDocMeAISettings.SaveConfig;
begin
  ValidateDatas;

  FConfig.AIProviderType(TDocMeAIProviderType(CbAI.ItemIndex)).ApiKey(MemAPIKey.Lines.Text.Trim)
    .ModelAI(Trim(CbModel.Text)).MaxTokens(StrToIntDef(EdtMaxToken.Text, MAX_TOKENS_AI))
    .Temperature(StrToFloat(Trim(EdtTemperature.Text))).SaveConfig;

  ShowMessage('Settings saved successfully');
end;

procedure TFrmDocMeAISettings.SwActiveSwitch(Sender: TObject);
begin
  FConfig.Active(SwActive.IsChecked);
end;

procedure TFrmDocMeAISettings.ValidateDatas;
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

  if Trim(CbModel.Text).IsEmpty then
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
