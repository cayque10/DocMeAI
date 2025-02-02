unit DocMe.Configurations.Config;

interface

uses
  System.Classes,
  System.SysUtils,
  System.JSON,
  System.IOUtils,
  DocMe.Configurations.Interfaces;

type
  TDocMeAIConfig = class(TInterfacedObject, IDocMeAIConfig)
  private
    FApiKey: string;
    FModelAI: string;
    FMaxTokens: Integer;
    FTemperature: Double;
    FConfigFilePath: string;

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
    function LoadFromFile: Boolean;

    /// <summary>
    /// Saves the current configuration data to a file.
    /// </summary>
    procedure SaveToFile;

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
  public
    destructor Destroy; override;

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
    function ApiKey(const Value: string): IDocMeAIConfig; overload;

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
    function ModelAI(const Value: string): IDocMeAIConfig; overload;

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
    function MaxTokens(const Value: Integer): IDocMeAIConfig; overload;

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
    function Temperature(const Value: Double): IDocMeAIConfig; overload;

    /// <summary>
    /// Creates a new instance of the IDocMeAIConfig interface.
    /// </summary>
    /// <returns>
    /// An instance of IDocMeAIConfig.
    /// </returns>
    class function New: IDocMeAIConfig;
  end;

const
  OPENAI_MODEL = 'gpt-4o-mini';
  MAX_TOKENS_AI = 2048;
  TEMPERATURE_AI = 0.3;

implementation

{ TDocMeAIConfig }

constructor TDocMeAIConfig.Create;
begin
  EnsureConfigDirectoryExists;
  FConfigFilePath := GetDefaultConfigPath;
  FApiKey := '';
  FModelAI := OPENAI_MODEL;
  FMaxTokens := MAX_TOKENS_AI;
  FTemperature := TEMPERATURE_AI;

  LoadConfig;
end;

destructor TDocMeAIConfig.Destroy;
begin
  SaveConfig;
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

function TDocMeAIConfig.LoadFromFile: Boolean;
var
  LJSON: TJSONObject;
  LContent: string;
begin
  Result := False;

  if not TFile.Exists(FConfigFilePath) then
    Exit;

  try
    LContent := TFile.ReadAllText(FConfigFilePath, TEncoding.UTF8);
    LJSON := TJSONObject.ParseJSONValue(LContent) as TJSONObject;

    if Assigned(LJSON) then
      try
        FApiKey := LJSON.GetValue<string>('ApiKey', '');
        FModelAI := LJSON.GetValue<string>('ModelAI', OPENAI_MODEL);
        FMaxTokens := LJSON.GetValue<Integer>('MaxTokens', MAX_TOKENS_AI);
        FTemperature := LJSON.GetValue<Double>('Temperature', TEMPERATURE_AI);
        Result := True;
      finally
        LJSON.Free;
      end;
  except
    on E: Exception do
      raise Exception.Create('Error loading configuration: ' + E.Message);
  end;
end;

procedure TDocMeAIConfig.SaveToFile;
var
  LJSON: TJSONObject;
  LContent: string;
begin
  LJSON := TJSONObject.Create;
  try
    LJSON.AddPair('ApiKey', FApiKey);
    LJSON.AddPair('ModelAI', FModelAI);
    LJSON.AddPair('MaxTokens', TJSONNumber.Create(FMaxTokens));
    LJSON.AddPair('Temperature', TJSONNumber.Create(FTemperature));

    LContent := LJSON.ToJSON;
    TFile.WriteAllText(FConfigFilePath, LContent, TEncoding.UTF8);
  finally
    LJSON.Free;
  end;
end;

function TDocMeAIConfig.LoadConfig: IDocMeAIConfig;
begin
  if not LoadFromFile then
    SaveToFile;

  Result := Self;
end;

function TDocMeAIConfig.SaveConfig: IDocMeAIConfig;
begin
  SaveToFile;

  Result := Self;
end;

function TDocMeAIConfig.GetDefaultConfigPath: string;
begin
  Result := TPath.Combine(TPath.GetHomePath, 'DocMeAI\config.json');
end;

function TDocMeAIConfig.ApiKey: string;
begin
  Result := FApiKey;
end;

function TDocMeAIConfig.ApiKey(const Value: string): IDocMeAIConfig;
begin
  FApiKey := Value;
  Result := Self;
end;

function TDocMeAIConfig.ModelAI: string;
begin
  Result := FModelAI;
end;

function TDocMeAIConfig.ModelAI(const Value: string): IDocMeAIConfig;
begin
  if not Value.Trim.IsEmpty then
    FModelAI := Value;

  Result := Self;
end;

class function TDocMeAIConfig.New: IDocMeAIConfig;
begin
  Result := Self.Create;
end;

function TDocMeAIConfig.MaxTokens: Integer;
begin
  Result := FMaxTokens;
end;

function TDocMeAIConfig.MaxTokens(const Value: Integer): IDocMeAIConfig;
begin
  if Value > 0 then
    FMaxTokens := Value;

  Result := Self;
end;

function TDocMeAIConfig.Temperature: Double;
begin
  Result := FTemperature;
end;

function TDocMeAIConfig.Temperature(const Value: Double): IDocMeAIConfig;
begin
  if Value > 0 then
    FTemperature := Value;

  Result := Self;
end;

end.
