unit DocMe.Configurations.Config;

interface

uses
  System.Classes,
  System.SysUtils,
  System.JSON,
  System.IOUtils,
  DocMe.Configurations.Interfaces,
  DocMe.AI.ProviderTypes,
  DocMe.AI.Interfaces,
  Encrypt.Interfaces;

type
  TDocMeAIConfig = class(TInterfacedObject, IDocMeAIConfig, IDocMeAIGit)
  private const
    ENCRYPT_KEY = 'wX37fr2562OqvqnWAobq3xzXBnV4GG2s';

  var
    FActive: Boolean;
    FApiKey: string;
    FModelAI: string;
    FMaxTokens: Integer;
    FTemperature: Double;
    FConfigFilePath: string;
    FProviderType: TDocMeAIProviderType;
    FAIModelsProvider: IAIModelsProvider;
    FIgnoreExtensions: string;
    FFilePath: string;
    FProjectPath: string;
    FEncrypt: IEncrypt;
    /// <summary>
    /// Initializes a new instance of the class.
    /// </summary>
    constructor Create;

    /// <summary>
    /// Loads configuration data from a file.
    /// </summary>
    /// <returns>
    /// Returns True if the file was successfully loaded; otherwise, False.
    /// </returns>
    function LoadFromFile(const AIndex: Integer): Boolean;

    /// <summary>
    /// Loads configuration settings from a Git file.
    /// </summary>
    /// <returns>
    /// Returns True if the configuration was loaded successfully; otherwise, returns False.
    /// </returns>
    function LoadFromFileConfigGit: Boolean;

    /// <summary>
    /// Saves the current configuration data to a file.
    /// </summary>
    procedure SaveToFile;

    /// <summary>
    /// Saves the current configuration to a file in Git format.
    /// </summary>
    procedure SaveToFileConfigGit;

    /// <summary>
    /// Retrieves the default path for the configuration file.
    /// </summary>
    /// <returns>
    /// Returns a string representing the default configuration path.
    /// </returns>
    function GetDefaultConfigPath: string;

    /// <summary>
    /// Ensures that the configuration directory exists, creating it if necessary.
    /// </summary>
    procedure EnsureConfigDirectoryExists;

    /// <summary>
    /// Retrieves the active provider type as an integer.
    /// </summary>
    /// <returns>
    /// An integer representing the active provider type.
    /// </returns>
    function GetActiveProviderType: Integer;

    /// <summary>
    /// Retrieves the file path as a string.
    /// </summary>
    /// <returns>
    /// A string containing the file path.
    /// </returns>
    function FilePath: string; overload;

    /// <summary>
    /// Sets the file path with the specified value.
    /// </summary>
    /// <param name="AValue">
    /// A string representing the file path to set.
    /// </param>
    /// <returns>
    /// An instance of <see cref="IDocMeAIGit"/> for method chaining.
    /// </returns>
    function FilePath(const AValue: string): IDocMeAIGit; overload;

    /// <summary>
    /// Retrieves the ignored extensions as a string.
    /// </summary>
    /// <returns>
    /// A string containing the ignored extensions.
    /// </returns>
    function IgnoreExtensions: string; overload;

    /// <summary>
    /// Sets the ignored extensions with the specified value.
    /// </summary>
    /// <param name="AExtensions">
    /// A string representing the extensions to ignore.
    /// </param>
    /// <returns>
    /// An instance of <see cref="IDocMeAIGit"/> for method chaining.
    /// </returns>
    function IgnoreExtensions(const AExtensions: string): IDocMeAIGit; overload;

    /// <summary>
    /// Retrieves the project path as a string.
    /// </summary>
    /// <returns>
    /// A string containing the project path.
    /// </returns>
    function ProjectPath: string; overload;

    /// <summary>
    /// Sets the project path with the specified value.
    /// </summary>
    /// <param name="AValue">
    /// A string representing the project path to set.
    /// </param>
    /// <returns>
    /// An instance of <see cref="IDocMeAIGit"/> for method chaining.
    /// </returns>
    function ProjectPath(const AValue: string): IDocMeAIGit; overload;

    /// <summary>
    /// Finalizes the configuration and returns an instance of <see cref="IDocMeAIConfig"/>.
    /// </summary>
    /// <returns>
    /// An instance of <see cref="IDocMeAIConfig"/> representing the finalized configuration.
    /// </returns>
    function &End: IDocMeAIConfig;
  public
    /// <summary>
    /// Destroys the instance of the class, releasing any resources held.
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    /// Creates a new instance of the IDocMeAIConfig interface.
    /// </summary>
    /// <returns>
    /// An instance of IDocMeAIConfig.
    /// </returns>
    class function New: IDocMeAIConfig;

    /// <summary>
    /// Loads the configuration settings.
    /// </summary>
    /// <returns>
    /// An instance of IDocMeAIConfig containing the loaded configuration.
    /// </returns>
    function LoadConfig: IDocMeAIConfig;

    /// <summary>
    /// Saves the current configuration settings.
    /// </summary>
    /// <returns>
    /// An instance of IDocMeAIConfig containing the saved configuration.
    /// </returns>
    function SaveConfig: IDocMeAIConfig;

    /// <summary>
    /// Gets the API key.
    /// </summary>
    /// <returns>
    /// A string representing the API key.
    /// </returns>
    function ApiKey: string; overload;

    /// <summary>
    /// Sets the API key.
    /// </summary>
    /// <param name="Value">
    /// A string representing the API key to set.
    /// </param>
    /// <returns>
    /// An instance of IDocMeAIConfig for method chaining.
    /// </returns>
    function ApiKey(const AValue: string): IDocMeAIConfig; overload;

    /// <summary>
    /// Gets the AI model.
    /// </summary>
    /// <returns>
    /// A string representing the AI model.
    /// </returns>
    function ModelAI: string; overload;

    /// <summary>
    /// Sets the AI model.
    /// </summary>
    /// <param name="Value">
    /// A string representing the AI model to set.
    /// </param>
    /// <returns>
    /// An instance of IDocMeAIConfig for method chaining.
    /// </returns>
    function ModelAI(const AValue: string): IDocMeAIConfig; overload;

    /// <summary>
    /// Gets the maximum number of tokens.
    /// </summary>
    /// <returns>
    /// An integer representing the maximum number of tokens.
    /// </returns>
    function MaxTokens: Integer; overload;

    /// <summary>
    /// Sets the maximum number of tokens.
    /// </summary>
    /// <param name="Value">
    /// An integer representing the maximum number of tokens to set.
    /// </param>
    /// <returns>
    /// An instance of IDocMeAIConfig for method chaining.
    /// </returns>
    function MaxTokens(const AValue: Integer): IDocMeAIConfig; overload;

    /// <summary>
    /// Gets the temperature setting.
    /// </summary>
    /// <returns>
    /// A double representing the temperature setting.
    /// </returns>
    function Temperature: Double; overload;

    /// <summary>
    /// Sets the temperature setting.
    /// </summary>
    /// <param name="Value">
    /// A double representing the temperature setting to set.
    /// </param>
    /// <returns>
    /// An instance of IDocMeAIConfig for method chaining.
    /// </returns>
    function Temperature(const AValue: Double): IDocMeAIConfig; overload;

    /// <summary>
    /// Retrieves the current AI provider type.
    /// </summary>
    /// <returns>
    /// The current AI provider type as a <see cref="TDocMeAIProviderType"/>.
    /// </returns>
    function AIProviderType: TDocMeAIProviderType; overload;

    /// <summary>
    /// Sets the AI provider type and returns the corresponding configuration.
    /// </summary>
    /// <param name="AType">
    /// The AI provider type to set, specified as a <see cref="TDocMeAIProviderType"/>.
    /// </param>
    /// <returns>
    /// An interface to the AI configuration as <see cref="IDocMeAIConfig"/>.
    /// </returns>
    function AIProviderType(const AType: TDocMeAIProviderType): IDocMeAIConfig; overload;

    /// <summary>
    /// Retrieves the current AI provider type.
    /// </summary>
    /// <returns>
    /// The current AI provider type as a <see cref="string"/>.
    /// </returns>
    function AIProviderTypeName: string;

    /// <summary>
    /// Gets the active state of the configuration.
    /// </summary>
    /// <returns>
    /// Returns a Boolean indicating whether the configuration is active.
    /// </returns>
    function Active: Boolean; overload;

    /// <summary>
    /// Sets the active state of the configuration.
    /// </summary>
    /// <param name="AValue">
    /// A Boolean value indicating the desired active state.
    /// </param>
    /// <returns>
    /// Returns an instance of <see cref="IDocMeAIConfig"/> for method chaining.
    /// </returns>
    function Active(const AValue: Boolean): IDocMeAIConfig; overload;

    /// <summary>
    /// Retrieves an instance of the IAIModelsProvider interface.
    /// </summary>
    /// <returns>
    /// An instance of <see cref="IAIModelsProvider"/> that provides access to AI models.
    /// </returns>
    function AIModelsProvider: IAIModelsProvider;

    /// <summary>
    /// Retrieves an instance of the IDocMeAIGit interface.
    /// </summary>
    /// <returns>
    /// An instance of <see cref="IDocMeAIGit"/>.
    /// </returns>
    function AIGit: IDocMeAIGit;
  end;

const
  MAX_TOKENS_AI = 2048;
  TEMPERATURE_AI = 0.3;

implementation

uses
  System.Generics.Collections,
  Encrypt.Main, FMX.Dialogs;

{ TDocMeAIConfig }

constructor TDocMeAIConfig.Create;
begin
  EnsureConfigDirectoryExists;
  FConfigFilePath := GetDefaultConfigPath;
  FApiKey := '';
  FModelAI := '';
  FMaxTokens := MAX_TOKENS_AI;
  FTemperature := TEMPERATURE_AI;
  FProviderType := TDocMeAIProviderType(GetActiveProviderType);
  FAIModelsProvider := TAIModelsProvider.New;
  FEncrypt := TEncryptMain.New;
  LoadConfig;
end;

destructor TDocMeAIConfig.Destroy;
begin
  inherited;
end;

procedure TDocMeAIConfig.EnsureConfigDirectoryExists;
var
  lConfigPath: string;
begin
  lConfigPath := ExtractFileDir(GetDefaultConfigPath);
  if not DirectoryExists(lConfigPath) then
    ForceDirectories(lConfigPath);
end;

function TDocMeAIConfig.FilePath: string;
begin
  Result := FFilePath;
end;

function TDocMeAIConfig.FilePath(const AValue: string): IDocMeAIGit;
begin
  FFilePath := AValue;
  Result := Self;
end;

function TDocMeAIConfig.LoadFromFile(const AIndex: Integer): Boolean;
var
  LContent: string;
  LConfigArray: TJSONArray;
  LParsedJSON: TJSONValue;
  LConfigObj: TJSONObject;
  LVal: TJSONValue;
begin
  Result := False;

  if not TFile.Exists(FConfigFilePath) then
    Exit;

  LContent := TFile.ReadAllText(FConfigFilePath, TEncoding.UTF8);
  LParsedJSON := TJSONObject.ParseJSONValue(LContent);
  try
    if not Assigned(LParsedJSON) or not(LParsedJSON is TJSONArray) then
      Exit;

    LConfigArray := TJSONArray(LParsedJSON);

    if (AIndex < 0) or (AIndex >= LConfigArray.Count) then
      Exit;

    if not(LConfigArray.Items[AIndex] is TJSONObject) then
      Exit;

    LConfigObj := TJSONObject(LConfigArray.Items[AIndex]);

    LVal := LConfigObj.GetValue('Active');
    if Assigned(LVal) and (LVal is TJSONBool) then
      FActive := TJSONBool(LVal).AsBoolean
    else
      FActive := False;

    LVal := LConfigObj.GetValue('ProviderType');
    if Assigned(LVal) and (LVal is TJSONNumber) then
      FProviderType := TDocMeAIProviderType(TJSONNumber(LVal).AsInt)
    else
      FProviderType := TDocMeAIProviderType.aiChatGPT;

    LVal := LConfigObj.GetValue('ApiKey');
    if Assigned(LVal) then
    begin
      try
        FApiKey := FEncrypt.AESDecrypt(LVal.Value, ENCRYPT_KEY)
      except
        ShowMessage('Unable to load API key. Enter the key again.');
      end;
    end
    else
      FApiKey := '';

    LVal := LConfigObj.GetValue('ModelAI');
    if Assigned(LVal) then
      FModelAI := LVal.Value
    else
      FModelAI := '';

    LVal := LConfigObj.GetValue('MaxTokens');
    if Assigned(LVal) and (LVal is TJSONNumber) then
      FMaxTokens := TJSONNumber(LVal).AsInt
    else
      FMaxTokens := MAX_TOKENS_AI;

    LVal := LConfigObj.GetValue('Temperature');
    if Assigned(LVal) and (LVal is TJSONNumber) then
      FTemperature := TJSONNumber(LVal).AsDouble
    else
      FTemperature := TEMPERATURE_AI;

    Result := True;
  finally
    LParsedJSON.Free;
  end;
end;

function TDocMeAIConfig.LoadFromFileConfigGit: Boolean;
var
  LContent: string;
  LConfigArray: TJSONArray;
  LParsedJSON, LGitValue: TJSONValue;
  LConfigObj: TJSONObject;
  I: Integer;
  LValue: string;
begin
  Result := False;

  if not TFile.Exists(FConfigFilePath) then
    Exit;

  LContent := TFile.ReadAllText(FConfigFilePath, TEncoding.UTF8);
  LParsedJSON := TJSONObject.ParseJSONValue(LContent);
  try
    if not Assigned(LParsedJSON) or not(LParsedJSON is TJSONArray) then
      Exit;

    LConfigArray := TJSONArray(LParsedJSON);

    for I := 0 to Pred(LConfigArray.Count) do
    begin

      LConfigObj := TJSONObject(LConfigArray.Items[I]);

      if LConfigObj.TryGetValue<TJSONValue>('Git', LGitValue) then
      begin
        if LGitValue.TryGetValue<string>('FilePath', LValue) then
          FFilePath := LValue
        else
          FFilePath := '';

        if LGitValue.TryGetValue<string>('IgnoreExtensions', LValue) then
          FIgnoreExtensions := LValue
        else
          FIgnoreExtensions := '';

        if LGitValue.TryGetValue<string>('ProjectPath', LValue) then
          FProjectPath := LValue
        else
          FProjectPath := '';

        Exit(True);
      end;

    end;
  finally
    LParsedJSON.Free;
  end;

end;

procedure TDocMeAIConfig.SaveToFile;
var
  LConfigArray: TJSONArray;
  LContent: string;
  LNewConfig, LConfig: TJSONObject;
  LParsedJSON: TJSONValue;
  I: Integer;
  lFound: Boolean;
  lKeyValue: string;
  lRemovedPair: TJSONPair;
begin
  if TFile.Exists(FConfigFilePath) then
  begin
    LContent := TFile.ReadAllText(FConfigFilePath, TEncoding.UTF8);
    LParsedJSON := TJSONObject.ParseJSONValue(LContent);
    if (LParsedJSON <> nil) and (LParsedJSON is TJSONArray) then
      LConfigArray := TJSONArray(LParsedJSON)
    else
    begin
      LConfigArray := TJSONArray.Create;
      LParsedJSON.Free;
    end;
  end
  else
    LConfigArray := TJSONArray.Create;

  lKeyValue := IntToStr(Ord(FProviderType));
  lFound := False;

  for I := 0 to Pred(LConfigArray.Count) do
  begin
    LConfig := TJSONObject(LConfigArray.Items[I]);
    if Assigned(LConfig.GetValue('ProviderType')) then
    begin
      if FActive then
      begin
        lRemovedPair := LConfig.RemovePair('Active');
        if Assigned(lRemovedPair) then
          lRemovedPair.Free;
        LConfig.AddPair('Active', TJSONBool.Create(False));
      end;

      if (LConfig.GetValue('ProviderType').Value = lKeyValue) then
      begin
        lRemovedPair := LConfig.RemovePair('Active');
        if Assigned(lRemovedPair) then
          lRemovedPair.Free;
        LConfig.AddPair('Active', TJSONBool.Create(FActive));

        lRemovedPair := LConfig.RemovePair('ApiKey');
        if Assigned(lRemovedPair) then
          lRemovedPair.Free;
        LConfig.AddPair('ApiKey', TJSONString.Create(FEncrypt.AESEncrypt(FApiKey, ENCRYPT_KEY)));

        lRemovedPair := LConfig.RemovePair('ModelAI');
        if Assigned(lRemovedPair) then
          lRemovedPair.Free;
        LConfig.AddPair('ModelAI', FModelAI);

        lRemovedPair := LConfig.RemovePair('MaxTokens');
        if Assigned(lRemovedPair) then
          lRemovedPair.Free;
        LConfig.AddPair('MaxTokens', TJSONNumber.Create(FMaxTokens));

        lRemovedPair := LConfig.RemovePair('Temperature');
        if Assigned(lRemovedPair) then
          lRemovedPair.Free;
        LConfig.AddPair('Temperature', TJSONNumber.Create(FTemperature));

        lFound := True;
      end;
    end;
  end;

  if not lFound then
  begin
    LNewConfig := TJSONObject.Create;
    try
      LNewConfig.AddPair('Active', TJSONBool.Create(FActive));
      LNewConfig.AddPair('ProviderType', TJSONNumber.Create(Ord(FProviderType)));
      LNewConfig.AddPair('ApiKey', FApiKey);
      LNewConfig.AddPair('ModelAI', FModelAI);
      LNewConfig.AddPair('MaxTokens', TJSONNumber.Create(FMaxTokens));
      LNewConfig.AddPair('Temperature', TJSONNumber.Create(FTemperature));
      LConfigArray.AddElement(LNewConfig);
    except
      LNewConfig.Free;
      raise;
    end;
  end;

  try
    LContent := LConfigArray.ToString;
    TFile.WriteAllText(FConfigFilePath, LContent, TEncoding.UTF8);
  finally
    LConfigArray.Free;
  end;
end;

procedure TDocMeAIConfig.SaveToFileConfigGit;
var
  LConfigArray: TJSONArray;
  LContent: string;
  LNewConfig, LNewConfig2, LConfig: TJSONObject;
  LParsedJSON: TJSONValue;
  I: Integer;
  lFound: Boolean;
  lRemovedPair: TJSONPair;
begin
  if TFile.Exists(FConfigFilePath) then
  begin
    LContent := TFile.ReadAllText(FConfigFilePath, TEncoding.UTF8);
    LParsedJSON := TJSONObject.ParseJSONValue(LContent);
    if (LParsedJSON <> nil) and (LParsedJSON is TJSONArray) then
      LConfigArray := TJSONArray(LParsedJSON)
    else
    begin
      LConfigArray := TJSONArray.Create;
      LParsedJSON.Free;
    end;
  end
  else
    LConfigArray := TJSONArray.Create;

  lFound := False;

  for I := 0 to Pred(LConfigArray.Count) do
  begin
    LConfig := TJSONObject(LConfigArray.Items[I]);
    if Assigned(LConfig.GetValue('Git')) then
    begin
      LNewConfig2 := TJSONObject.ParseJSONValue(LConfig.GetValue('Git').ToJSON) as TJSONObject;

      lRemovedPair := LNewConfig2.RemovePair('FilePath');
      if Assigned(lRemovedPair) then
        lRemovedPair.Free;
      LNewConfig2.AddPair('FilePath', TJSONString.Create(FFilePath));

      lRemovedPair := LNewConfig2.RemovePair('IgnoreExtensions');
      if Assigned(lRemovedPair) then
        lRemovedPair.Free;
      LNewConfig2.AddPair('IgnoreExtensions', TJSONString.Create(FIgnoreExtensions));

      lRemovedPair := LNewConfig2.RemovePair('ProjectPath');
      if Assigned(lRemovedPair) then
        lRemovedPair.Free;
      LNewConfig2.AddPair('ProjectPath', TJSONString.Create(FProjectPath));

      lRemovedPair := LConfig.RemovePair('Git');
      if Assigned(lRemovedPair) then
        lRemovedPair.Free;
      LConfig.AddPair('Git', LNewConfig2);

      lFound := True;
    end;
  end;

  if not lFound then
  begin
    LNewConfig := TJSONObject.Create;
    try
      LNewConfig2 := TJSONObject.Create;
      try
        LNewConfig2.AddPair('FilePath', TJSONString.Create(FFilePath));
        LNewConfig2.AddPair('IgnoreExtensions', TJSONString.Create(FIgnoreExtensions));
        LNewConfig2.AddPair('ProjectPath', TJSONString.Create(FProjectPath));
        LNewConfig.AddPair('Git', LNewConfig2);
        LConfigArray.AddElement(LNewConfig);
      except
        LNewConfig2.Free;
        raise;
      end;
    except
      LNewConfig.Free;
      raise;
    end;
  end;

  try
    LContent := LConfigArray.ToString;
    TFile.WriteAllText(FConfigFilePath, LContent, TEncoding.UTF8);
  finally
    LConfigArray.Free;
  end;
end;

function TDocMeAIConfig.LoadConfig: IDocMeAIConfig;
begin
  if not LoadFromFile(Ord(FProviderType)) then
    SaveToFile;

  if not LoadFromFileConfigGit then
    SaveToFileConfigGit;

  Result := Self;
end;

function TDocMeAIConfig.SaveConfig: IDocMeAIConfig;
begin
  SaveToFile;
  SaveToFileConfigGit;

  Result := Self;
end;

function TDocMeAIConfig.GetActiveProviderType: Integer;
var
  LContent: string;
  LParsedJSON: TJSONValue;
  LJSONArray: TJSONArray;
  LJSONObj: TJSONObject;
  I: Integer;
  LActiveValue: TJSONValue;
  LProvideTypeValue: TJSONValue;
begin
  Result := 0;

  if not TFile.Exists(FConfigFilePath) then
    Exit;

  LContent := TFile.ReadAllText(FConfigFilePath, TEncoding.UTF8);
  LParsedJSON := TJSONObject.ParseJSONValue(LContent);
  try
    if Assigned(LParsedJSON) and (LParsedJSON is TJSONArray) then
    begin
      LJSONArray := TJSONArray(LParsedJSON);
      for I := 0 to LJSONArray.Count - 1 do
      begin
        if LJSONArray.Items[I] is TJSONObject then
        begin
          LJSONObj := TJSONObject(LJSONArray.Items[I]);
          LActiveValue := LJSONObj.GetValue('Active');
          if Assigned(LActiveValue) and (LActiveValue is TJSONBool) then
          begin
            if TJSONBool(LActiveValue).AsBoolean then
            begin
              LProvideTypeValue := LJSONObj.GetValue('ProviderType');
              if Assigned(LProvideTypeValue) and (LProvideTypeValue is TJSONNumber) then
              begin
                Result := TJSONNumber(LProvideTypeValue).AsInt;
                Exit;
              end;
            end;
          end;
        end;
      end;
    end;
  finally
    LParsedJSON.Free;
  end;
end;

function TDocMeAIConfig.GetDefaultConfigPath: string;
begin
  Result := TPath.Combine(TPath.GetHomePath, 'DocMeAI\config.json');
end;

function TDocMeAIConfig.IgnoreExtensions: string;
begin
  Result := FIgnoreExtensions;
end;

function TDocMeAIConfig.IgnoreExtensions(const AExtensions: string): IDocMeAIGit;
begin
  FIgnoreExtensions := AExtensions;
  Result := Self;
end;

function TDocMeAIConfig.ApiKey: string;
begin
  Result := FApiKey;
end;

function TDocMeAIConfig.&End: IDocMeAIConfig;
begin
  Result := Self;
end;

function TDocMeAIConfig.Active(const AValue: Boolean): IDocMeAIConfig;
begin
  Result := Self;
  FActive := AValue;
end;

function TDocMeAIConfig.AIProviderTypeName: string;
begin
  Result := DOCME_AI_PROVIDER_NAMES_TYPE[FProviderType];
end;

function TDocMeAIConfig.Active: Boolean;
begin
  Result := FActive;
end;

function TDocMeAIConfig.AIGit: IDocMeAIGit;
begin
  Result := Self;
end;

function TDocMeAIConfig.AIModelsProvider: IAIModelsProvider;
begin
  Result := FAIModelsProvider;
end;

function TDocMeAIConfig.AIProviderType(const AType: TDocMeAIProviderType): IDocMeAIConfig;
begin
  Result := Self;
  FProviderType := AType;
end;

function TDocMeAIConfig.AIProviderType: TDocMeAIProviderType;
begin
  Result := FProviderType;
end;

function TDocMeAIConfig.ApiKey(const AValue: string): IDocMeAIConfig;
begin
  FApiKey := AValue;
  Result := Self;
end;

function TDocMeAIConfig.ModelAI: string;
begin
  Result := FModelAI;
end;

function TDocMeAIConfig.ModelAI(const AValue: string): IDocMeAIConfig;
begin
  if not AValue.Trim.IsEmpty then
    FModelAI := AValue;

  Result := Self;
end;

class function TDocMeAIConfig.New: IDocMeAIConfig;
begin
  Result := Self.Create;
end;

function TDocMeAIConfig.ProjectPath(const AValue: string): IDocMeAIGit;
begin
  FProjectPath := AValue;
  Result := Self;
end;

function TDocMeAIConfig.ProjectPath: string;
begin
  Result := FProjectPath;
end;

function TDocMeAIConfig.MaxTokens: Integer;
begin
  Result := FMaxTokens;
end;

function TDocMeAIConfig.MaxTokens(const AValue: Integer): IDocMeAIConfig;
begin
  if AValue > 0 then
    FMaxTokens := AValue;

  Result := Self;
end;

function TDocMeAIConfig.Temperature: Double;
begin
  Result := FTemperature;
end;

function TDocMeAIConfig.Temperature(const AValue: Double): IDocMeAIConfig;
begin
  if AValue > 0 then
    FTemperature := AValue;

  Result := Self;
end;

end.
