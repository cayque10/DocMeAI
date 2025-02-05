unit WS.Base;

interface

uses
  System.Classes,
  WS.Interfaces,
  WS.Factory,
  WS.Token,
  System.JSON,
  System.SysUtils;

type
  TTipoURL = (tuDesconhecido, tuQuery, tuPath);

  TWSBase = class(TInterfacedObject, IWSBase, IWSRequest)
  private
    class var FInstance: IWSBase;
    class var FToken: IWSToken;

  var
    FBaseURL: String;
    FParams: TStrings;
    FResource: String;
    FResponseObject: TJSONObject;
    FResponse: String;
    constructor Create;
    function FormatUrl(const AUrl: String): String;
    function GetFullBaseUrl: String;
    procedure ValidateUrl;
    procedure CheckResponse;
    function GetParams: String;
    procedure SetBearerToken;
  protected
    FWSFactory: TWSFactory;
    FHttpClient: IWSRequest;

  public
    destructor Destroy; override;
    // class function NewInstance: TObject; override;
    class function GetInstance: IWSBase;
    class function New: IWSBase;
    function GetStream(const AResource: String): TStream;
    function Get(const AResource: String): String;
    function Post(const AResource: String; const ASource: TStream): String;
    function PostFile(const AResource: String; const APathFile: String): String;
    function Patch(const AResource: String; const ASource, AResponseContent: TStream): String;
    function Put(const AResource: String; const ASource: TStream): String;
    function Delete(const AResource: String; const ASource: TStream): String;
    function ResponseCode: Integer;
    function ErrorMessage: String;
    function BaseMessage: String;
    function WSResquest: IWSRequest;
    function GetBaseUrl: String;
    function Params: TStrings;
    function SetBaseUrl(const AUrl: String): IWSBase;
    function Authentication(const AResource: String; const ASource: TStream): String;
    procedure ClearAuthentication;
    procedure BearerToken(const AToken: String);
    procedure Clear;
    function Token: String;
    procedure CheckStatusConnection(const AUrl: String);
    function HeaderValue(const AName: String): String;
    procedure TokenValidate(const AValue: String);
    procedure RefreshToken(const AValue: String);
    function Response: String;
  end;

  EWSExceptionBase = class(Exception);

  EWSUnauthorized = class(EWSExceptionBase);
  EWSBadRequest = class(EWSExceptionBase);
  EWSForbidden = class(EWSExceptionBase);
  EWSNotFound = class(EWSExceptionBase);
  EWSNotAcceptable = class(EWSExceptionBase);
  EWSServerError = class(EWSExceptionBase);
  EWSNoConnection = class(EWSExceptionBase);

implementation

uses
  Rest.JSON,
  WS.Common,
  WS.Parser,
  Utils.JSON.Cleaner,
  Utils.Date,
  Utils.Resource.Strings;

{ TWSBase }

function TWSBase.Authentication(const AResource: String; const ASource: TStream): String;
var
  LUrl: String;
  LToken: String;
begin
  FResource := AResource;
  ValidateUrl;
  LUrl := GetFullBaseUrl;
  FResponse := FHttpClient.Post(LUrl, ASource);
  CheckResponse;
  LToken := FHttpClient.HeaderValue('Authorization').Trim.Replace('Bearer ', '');
  FToken.Extract(FResponse);
  FToken.Token(LToken);
  SetBearerToken;
  Result := FResponse;
end;

function TWSBase.BaseMessage: String;
begin
  Result := FHttpClient.BaseMessage;
end;

procedure TWSBase.BearerToken(const AToken: String);
begin
  FToken.Token(AToken);
  FHttpClient.BearerToken(AToken);
end;

procedure TWSBase.CheckResponse;
var
  lMsg: string;
begin
  if ResponseCode in [TWSHTTPCode.WS_HTTP_CODE_OK,
                      TWSHTTPCode.WS_HTTP_CODE_CREATED,
                      TWSHTTPCode.WS_HTTP_CODE_ACCEPTED,
                      TWSHTTPCode.WS_HTTP_CODE_NON_AUTHORITATIVE_INFO,
                      TWSHTTPCode.WS_HTTP_CODE_NO_CONTENT] then
    Exit;

  lMsg := Format('HTTP Error %d: %s', [ResponseCode, FResponse]);

  case ResponseCode of
    TWSHTTPCode.WS_HTTP_CODE_BAD_REQUEST:
      raise EWSBadRequest.Create(lMsg);
    TWSHTTPCode.WS_HTTP_CODE_UNAUTHORIZED:
      raise EWSUnauthorized.Create(lMsg);
    TWSHTTPCode.WS_HTTP_CODE_FORBIDDEN:
      raise EWSForbidden.Create(lMsg);
    TWSHTTPCode.WS_HTTP_CODE_NOT_FOUND:
      raise EWSNotFound.Create(lMsg);
    TWSHTTPCode.WS_HTTP_CODE_INTERNAL_SERVER_ERROR,
    TWSHTTPCode.WS_HTTP_CODE_NOT_IMPLEMENTED,
    TWSHTTPCode.WS_HTTP_CODE_BAD_GATEWAY,
    TWSHTTPCode.WS_HTTP_CODE_SERVICE_UNAVAILABLE:
      raise EWSServerError.Create(lMsg);
  else
    raise EWSExceptionBase.Create(lMsg);
  end;
end;

procedure TWSBase.CheckStatusConnection(const AUrl: String);
  procedure _Check;
  begin
    if ResponseCode <> TWSHTTPCode.WS_HTTP_CODE_OK then
      raise EWSNoConnection.Create(SConnectionIssue);
  end;

begin
  try
    FHttpClient.Get(AUrl);
    _Check;
  except
    on E: Exception do
      _Check;
  end;
end;

procedure TWSBase.SetBearerToken;
begin
  if FToken.Token.Trim.IsEmpty then
    exit;

  FHttpClient.BearerToken(FToken.Token);
end;

procedure TWSBase.Clear;
begin
  Params.Clear;
end;

procedure TWSBase.ClearAuthentication;
begin
  FToken.DeleteCache;
  FHttpClient.BearerToken('');
end;

constructor TWSBase.Create;
begin
  FResponseObject := TJSONObject.Create;
  FBaseURL := '';
  FParams := TStringList.Create;
  FParams.StrictDelimiter := True;
  FParams.Delimiter := '&';
  FParams.NameValueSeparator := '=';

  FWSFactory := TWSFactory.Create;
  FHttpClient := FWSFactory.HttpClient;
  if not Assigned(FToken) then
    FToken := TWSToken.New;
end;

destructor TWSBase.Destroy;
begin
  FResponseObject.Free;
  FParams.Free;
  FWSFactory.Free;
  inherited;
end;

function TWSBase.ErrorMessage: String;
begin
  Result := FHttpClient.ErrorMessage;
end;

function TWSBase.FormatUrl(const AUrl: String): String;
var
  LUrl: String;
begin
  LUrl := AUrl;
  if LUrl[Length(LUrl)] <> '/' then
    LUrl := LUrl + '/';
  Result := LUrl;
end;

class function TWSBase.GetInstance: IWSBase;
begin
  Result := TWSBase.Create;
end;

function TWSBase.GetParams: String;
var
  lType: TTipoURL;

  function _DetectUrlType(const AInput: string): TTipoURL;
  begin
    if Pos('=', AInput) > 0 then
      Result := tuQuery
    else if Pos('/', AInput) > 0 then
      Result := tuPath
    else
      Result := tuDesconhecido;
  end;

begin
  if FParams.Count <= 0 then
    exit('');

  lType := _DetectUrlType(FParams.DelimitedText);
  if lType = tuQuery then
    Result := '?' + FParams.Text
  else
  begin
    Result := FParams.Text;
    if Result.StartsWith('/') then
      Result := Result.Remove(0, 1);
  end;
end;

function TWSBase.Get(const AResource: String): String;
var
  LUrl: String;
begin
  FResource := AResource;
  ValidateUrl;
  LUrl := GetFullBaseUrl + GetParams;
  SetBearerToken;
  FResponse := FHttpClient.Get(LUrl);
  CheckResponse;
  Result := FResponse;
  Clear;
end;

function TWSBase.GetBaseUrl: String;
begin
  Result := FBaseURL;
end;

function TWSBase.GetStream(const AResource: String): TStream;
var
  LUrl: String;
begin
  FResource := AResource;
  ValidateUrl;
  SetBearerToken;
  LUrl := GetFullBaseUrl + GetParams;
  Result := FHttpClient.GetStream(LUrl);
  Clear;
end;

function TWSBase.HeaderValue(const AName: String): String;
begin
  Result := FHttpClient.HeaderValue(AName);
end;

class function TWSBase.New: IWSBase;
begin
  if not Assigned(FInstance) then
    FInstance := Self.Create;

  Result := FInstance;
end;

function TWSBase.GetFullBaseUrl: String;
var
  LResource: string;
begin
  LResource := FResource;

  Result := FBaseURL + LResource;

  if not LResource.IsEmpty then
  begin
    if not(Result.IsEmpty or Result.EndsWith('/')) and not(LResource.EndsWith('/') or LResource.StartsWith('?') or
      LResource.StartsWith('#')) then
    begin
      Result := Result + '/';
    end;
  end;
end;

function TWSBase.Post(const AResource: String; const ASource: TStream): String;
var
  LUrl: String;
begin
  FResource := AResource;
  ValidateUrl;
  LUrl := GetFullBaseUrl + GetParams;
  SetBearerToken;
  FResponse := FHttpClient.Post(LUrl, ASource);
  CheckResponse;
  Result := FResponse;
  Clear;
end;

function TWSBase.PostFile(const AResource, APathFile: String): String;
var
  LUrl: String;
begin
  FResource := AResource;
  ValidateUrl;
  LUrl := GetFullBaseUrl + GetParams;
  SetBearerToken;
  FResponse := FHttpClient.PostFile(LUrl, APathFile);
  CheckResponse;
  Result := FResponse;
  Clear;
end;

function TWSBase.Params: TStrings;
begin
  Result := FParams;
end;

function TWSBase.Patch(const AResource: String; const ASource, AResponseContent: TStream): String;
var
  LUrl: String;
begin
  FResource := AResource;
  ValidateUrl;
  LUrl := GetFullBaseUrl + GetParams;
  SetBearerToken;
  FResponse := FHttpClient.Patch(LUrl, ASource, AResponseContent);
  CheckResponse;
  Result := FResponse;
  Clear;
end;

function TWSBase.Put(const AResource: String; const ASource: TStream): String;
var
  LUrl: String;
begin
  FResource := AResource;
  ValidateUrl;
  LUrl := GetFullBaseUrl + GetParams;
  SetBearerToken;
  FResponse := FHttpClient.Put(LUrl, ASource);
  CheckResponse;
  Result := FResponse;
  Clear;
end;

procedure TWSBase.RefreshToken(const AValue: String);
begin
  FToken.RefreshToken(AValue);
end;

function TWSBase.Response: String;
begin
  Result := FResponse;
end;

function TWSBase.ResponseCode: Integer;
begin
  Result := FHttpClient.ResponseCode;
end;

function TWSBase.SetBaseUrl(const AUrl: String):IWSBase;
begin
  Result := Self;
  FBaseURL := FormatUrl(AUrl);
end;

function TWSBase.Token: String;
begin
  Result := FToken.Token;
end;

procedure TWSBase.TokenValidate(const AValue: String);
begin
  FToken.TokenValidate(AValue);
end;

procedure TWSBase.ValidateUrl;
begin
  if FBaseURL.IsEmpty then
    raise Exception.Create('A url base não foi informada!');
end;

function TWSBase.WSResquest: IWSRequest;
begin
  Result := Self;
end;

function TWSBase.Delete(const AResource: String; const ASource: TStream): String;
var
  LUrl: String;
begin
  FResource := AResource;
  ValidateUrl;
  LUrl := GetFullBaseUrl + GetParams;
  SetBearerToken;
  FResponse := FHttpClient.Delete(LUrl, ASource);
  CheckResponse;
  Result := FResponse;
  Clear;
end;

end.
