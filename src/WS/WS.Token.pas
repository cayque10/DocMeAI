unit WS.Token;

{
  classe responsável pela manipulação do token de acesso ao sistema.
  Efetua recuperação de token em cache, tratamentos de validade etc.
}
interface

type
  IWSToken = interface
    ['{48A153A9-8401-4E7E-97BF-5A89BFA52198}']

    /// <summary>
    /// Validates the current state or data.
    /// </summary>
    /// <returns>
    /// Returns True if the validation is successful; otherwise, False.
    /// </returns>
    function IsValidate: Boolean;

    /// <summary>
    /// Extracts data from the provided string and processes it.
    /// </summary>
    /// <param name="AData">
    /// The string containing the data to be extracted.
    /// </param>
    procedure Extract(const AData: String);

    /// <summary>
    /// Saves the provided data into the cache.
    /// </summary>
    /// <param name="AData">
    /// The string containing the data to be saved in the cache.
    /// </param>
    procedure SaveInCache(const AData: String);

    /// <summary>
    /// Deletes the cached data.
    /// </summary>
    procedure DeleteCache;

    /// <summary>
    /// Retrieves the current token.
    /// </summary>
    /// <returns>
    /// Returns the current token as a string.
    /// </returns>
    function Token: String; overload;

    /// <summary>
    /// Sets the token to the provided value.
    /// </summary>
    /// <param name="AValue">
    /// The string containing the new token value.
    /// </param>
    procedure Token(const AValue: String); overload;

    /// <summary>
    /// Refreshes the token and retrieves the new token.
    /// </summary>
    /// <returns>
    /// Returns the refreshed token as a string.
    /// </returns>
    function RefreshToken: String; overload;

    /// <summary>
    /// Sets the refreshed token to the provided value.
    /// </summary>
    /// <param name="AValue">
    /// The string containing the new refreshed token value.
    /// </param>
    procedure RefreshToken(const AValue: String); overload;

    /// <summary>
    /// Validates the current token and retrieves the validation result.
    /// </summary>
    /// <returns>
    /// Returns the validation result of the token as a string.
    /// </returns>
    function TokenValidate: String; overload;

    /// <summary>
    /// Validates the provided token value.
    /// </summary>
    /// <param name="AValue">
    /// The string containing the token value to validate.
    /// </param>
    procedure TokenValidate(const AValue: String); overload;

  end;

  TWSToken = class(TInterfacedObject, IWSToken)
  class var
    FInstance: IWSToken;
  private
    FToken: String;
    FRefreshToken: String;
    FTokenValidate: String;

    /// <summary>
    /// Retrieves a string value from the cache.
    /// </summary>
    /// <returns>
    /// A string representing the cached value.
    /// </returns>
    function GetInCache: String;

    /// <summary>
    /// Checks if the provided date has expired.
    /// </summary>
    /// <param name="ADate">
    /// The date to be checked for expiration.
    /// </param>
    /// <returns>
    /// True if the date is expired; otherwise, false.
    /// </returns>
    function IsExpiredDate(const ADate: TDateTime): Boolean;

    /// <summary>
    /// Initializes a new instance of the class.
    /// </summary>
    constructor Create;
  protected
  public
    destructor Destroy; override;

    /// <summary>
    /// Creates a new instance of IWSToken.
    /// </summary>
    /// <returns>
    /// A new instance of <see cref="IWSToken"/>.
    /// </returns>
    class function New: IWSToken;

    /// <summary>
    /// Validates the current state or data.
    /// </summary>
    /// <returns>
    /// Returns True if the validation is successful; otherwise, False.
    /// </returns>
    function IsValidate: Boolean;

    /// <summary>
    /// Extracts data from the provided string and processes it.
    /// </summary>
    /// <param name="AData">
    /// The string containing the data to be extracted.
    /// </param>
    procedure Extract(const AData: String);

    /// <summary>
    /// Saves the provided data into the cache.
    /// </summary>
    /// <param name="AData">
    /// The string containing the data to be saved in the cache.
    /// </param>
    procedure SaveInCache(const AData: String);

    /// <summary>
    /// Deletes the cached data.
    /// </summary>
    procedure DeleteCache;

    /// <summary>
    /// Retrieves the current token.
    /// </summary>
    /// <returns>
    /// Returns the current token as a string.
    /// </returns>
    function Token: String; overload;

    /// <summary>
    /// Sets the token to the provided value.
    /// </summary>
    /// <param name="AValue">
    /// The string containing the new token value.
    /// </param>
    procedure Token(const AValue: String); overload;

    /// <summary>
    /// Refreshes the token and retrieves the new token.
    /// </summary>
    /// <returns>
    /// Returns the refreshed token as a string.
    /// </returns>
    function RefreshToken: String; overload;

    /// <summary>
    /// Sets the refreshed token to the provided value.
    /// </summary>
    /// <param name="AValue">
    /// The string containing the new refreshed token value.
    /// </param>
    procedure RefreshToken(const AValue: String); overload;

    /// <summary>
    /// Validates the current token and retrieves the validation result.
    /// </summary>
    /// <returns>
    /// Returns the validation result of the token as a string.
    /// </returns>
    function TokenValidate: String; overload;

    /// <summary>
    /// Validates the provided token value.
    /// </summary>
    /// <param name="AValue">
    /// The string containing the token value to validate.
    /// </param>
    procedure TokenValidate(const AValue: String); overload;

  const
    DATA_ACCESS_TOKEN = 'JPDAccess.data';
  end;

implementation

uses
  System.Classes,
  System.IOUtils,
  System.SysUtils,
  System.JSON,
  System.DateUtils,
  Utils.Date;

{ TWSToken }

function TWSToken.IsExpiredDate(const ADate: TDateTime): Boolean;
begin
  Result := ADate < Now;
end;

constructor TWSToken.Create;
begin

end;

procedure TWSToken.DeleteCache;
var
  LFilePath: String;
begin
  LFilePath := IncludeTrailingPathDelimiter(TPath.GetTempPath) + DATA_ACCESS_TOKEN;

  if TFile.Exists(LFilePath) then
    TFile.Delete(LFilePath);
end;

destructor TWSToken.Destroy;
begin

  inherited;
end;

procedure TWSToken.Extract(const AData: String);
var
  LValue, LValueData: TJSONValue;
begin
  LValue := TJSONObject.ParseJSONValue(AData);
  try
    LValueData := LValue.GetValue<TJSONValue>('data[0]');
    LValueData.TryGetValue<String>('token', FToken);
    LValueData.TryGetValue<String>('refresh_token', FRefreshToken);
    LValueData.TryGetValue<String>('token_jwt_validate', FTokenValidate);
  finally
    LValue.Free;
  end;
end;

function TWSToken.GetInCache: String;
var
  LToken: TStrings;
  LFilePath: String;
begin
  LFilePath := IncludeTrailingPathDelimiter(TPath.GetTempPath) + DATA_ACCESS_TOKEN;

  if not TFile.Exists(LFilePath) then
    Exit('');

  LToken := TStringList.Create;
  try
    LToken.LoadFromFile(LFilePath);
    Result := LToken.Text;
  finally
    LToken.Free;
  end;
end;

function TWSToken.IsValidate: Boolean;
var
  LExpiredDate: TDateTime;
  LJson: TJSONValue;
begin
  LJson := TJSONObject.ParseJSONValue(GetInCache);
  try
    FToken := LJson.GetValue<String>('token');
    LExpiredDate := TUtilsDate.GetLocalTime(UnixToDateTime(LJson.GetValue<String>('expiredData').ToInt64));
    Result := (not FToken.IsEmpty) and (not IsExpiredDate(LExpiredDate));
  finally
    LJson.Free;
  end;
end;

class function TWSToken.New: IWSToken;
begin
  if not Assigned(FInstance) then
    FInstance := Self.Create;
  Result := FInstance;
end;

procedure TWSToken.RefreshToken(const AValue: String);
begin
  FRefreshToken := AValue;
end;

function TWSToken.RefreshToken: String;
begin
  Result := FRefreshToken;
end;

procedure TWSToken.SaveInCache(const AData: String);
var
  LData: TStrings;
  LPath: String;
begin
  LPath := IncludeTrailingPathDelimiter(TPath.GetTempPath);
  if not TDirectory.Exists(LPath) then
    TDirectory.CreateDirectory(LPath);

  LPath := LPath + DATA_ACCESS_TOKEN;

  LData := TStringList.Create;
  try
    LData.Add(AData);
    LData.SaveToFile(LPath);
  finally
    LData.Free;
  end;
end;

procedure TWSToken.Token(const AValue: String);
begin
  FToken := AValue;
end;

procedure TWSToken.TokenValidate(const AValue: String);
begin
  FTokenValidate := AValue;
end;

function TWSToken.TokenValidate: String;
begin
  Result := FTokenValidate;
end;

function TWSToken.Token: String;
begin
  Result := FToken;
end;

end.
