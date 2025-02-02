unit WS.Token;

{
  classe responsável pela manipulação do token de acesso ao sistema.
  Efetua recuperação de token em cache, tratamentos de validade etc.
}
interface

type
  IWSToken = interface
    ['{48A153A9-8401-4E7E-97BF-5A89BFA52198}']
    function IsValidate: Boolean;
    procedure Extract(const AData: String);
    procedure SaveInCache(const AData: String);
    procedure DeleteCache;
    function Token: String; overload;
    procedure Token(const AValue: String); overload;
    function RefreshToken: String; overload;
    procedure RefreshToken(const AValue: String); overload;
    function TokenValidate: String; overload;
    procedure TokenValidate(const AValue: String); overload;
  end;

  TWSToken = class(TInterfacedObject, IWSToken)
  class var
    FInstance: IWSToken;
  private
    FToken: String;
    FRefreshToken: String;
    FTokenValidate: String;
    function GetInCache: String;
    function IsExpiredDate(const ADate: TDateTime): Boolean;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IWSToken;
    function IsValidate: Boolean;
    procedure Extract(const AData: String);
    procedure SaveInCache(const AData: String);
    procedure DeleteCache;
    function Token: String; overload;
    procedure Token(const AValue: String); overload;
    function RefreshToken: String; overload;
    procedure RefreshToken(const AValue: String); overload;
    function TokenValidate: String; overload;
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
