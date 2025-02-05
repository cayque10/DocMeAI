unit WS.Http.Net;

interface

uses
  WS.Interfaces,
  System.Classes,
  System.Net.URLClient,
  System.Net.HttpClient,
  System.Net.HttpClientComponent,
  System.SyncObjs;

type
  TWSHttpNetHttpClient = class(TInterfacedObject, IWSRequest)
  private
    FHTTPClient: TNetHTTPClient;
    FErrorMessage: String;
    FBaseMessage: String;
    FHttpResponse: IHTTPResponse;
    FCriticalSection: TCriticalSection;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    function GetStream(const AUrl: String): TStream;
    function Get(const AUrl: String): String;
    function Post(const AUrl: String; const ASource: TStream): String;
    function PostFile(const AResource: String; const APathFile: String): String;
    function Patch(const AUrl: String; const ASource, AResponseContent: TStream): String;
    function Put(const AUrl: String; const ASource: TStream): String;
    function Delete(const AUrl: String; const ASource: TStream): String;
    function ResponseCode: Integer;
    function ErrorMessage: String;
    function BaseMessage: String;
    procedure BearerToken(const AToken: String);
    function HeaderValue(const AName: String): String;
  end;

implementation

uses
  System.Net.Mime,
  WS.Common, System.SysUtils;

{ TWSHttpNetHttpClient }

procedure TWSHttpNetHttpClient.BearerToken(const AToken: String);
begin
  FHTTPClient.CustomHeaders['Authorization'] := 'Bearer ' + AToken;
end;

constructor TWSHttpNetHttpClient.Create;
begin
  inherited Create;
  FCriticalSection := TCriticalSection.Create;
  FHTTPClient := TNetHTTPClient.Create(nil);
  FHTTPClient.ContentType := 'application/json; charset=utf-8';
  FHTTPClient.UserAgent := 'Mozilla/5.0 (compatible;Indy Library)';
  FHTTPClient.Accept := '*/*';
  FHTTPClient.CustomHeaders['Accept-Charset'] := 'UTF-8';
  FHTTPClient.AcceptEncoding := 'gzip, deflate, br';
  FHTTPClient.ConnectionTimeout := 60000;
  FHTTPClient.ResponseTimeout := 30000;
end;

function TWSHttpNetHttpClient.Delete(const AUrl: String; const ASource: TStream): String;
begin
  FHttpResponse := FHTTPClient.Delete(AUrl);
  Result := FHttpResponse.ContentAsString;
end;

destructor TWSHttpNetHttpClient.Destroy;
begin
  FHTTPClient.Free;
  FCriticalSection.Free;
  inherited;
end;

function TWSHttpNetHttpClient.ErrorMessage: String;
begin
  Result := FErrorMessage;
end;

function TWSHttpNetHttpClient.Get(const AUrl: String): String;
begin
  FCriticalSection.Enter;
  try
    FHttpResponse := FHTTPClient.Get(AUrl);
    Result := FHttpResponse.ContentAsString(TEncoding.UTF8);
  finally
    FCriticalSection.Leave;
  end;
end;

function TWSHttpNetHttpClient.GetStream(const AUrl: String): TStream;
begin
  FHttpResponse := FHTTPClient.Get(AUrl);
  Result := FHttpResponse.ContentStream;
end;

function TWSHttpNetHttpClient.HeaderValue(const AName: String): String;
begin
  Result := FHttpResponse.HeaderValue[AName];
end;

function TWSHttpNetHttpClient.BaseMessage: String;
begin
  Result := FBaseMessage;
end;

function TWSHttpNetHttpClient.Patch(const AUrl: String; const ASource, AResponseContent: TStream): String;
begin
  FHttpResponse := FHTTPClient.Patch(AUrl, ASource);
  Result := FHttpResponse.ContentAsString;
end;

function TWSHttpNetHttpClient.Post(const AUrl: String; const ASource: TStream): String;
begin
  FHttpResponse := FHTTPClient.Post(AUrl, ASource);
  Result := FHttpResponse.ContentAsString;
end;

function TWSHttpNetHttpClient.PostFile(const AResource: String; const APathFile: String): String;
var
  lParam: TMultipartFormData;
begin
  lParam := TMultipartFormData.Create(false);
  try
    lParam.AddFile('file', APathFile);
    FHttpResponse := FHTTPClient.Post(AResource, lParam);
    Result := FHttpResponse.ContentAsString;
  finally
    lParam.Free;
  end;
end;

function TWSHttpNetHttpClient.Put(const AUrl: String; const ASource: TStream): String;
begin
  FHttpResponse := FHTTPClient.Put(AUrl, ASource);
  Result := FHttpResponse.ContentAsString;
end;

function TWSHttpNetHttpClient.ResponseCode: Integer;
begin
  if not Assigned(FHTTPClient) or not Assigned(FHttpResponse) then
    Result := TWSHTTPCode.WS_HTTP_CODE_BAD_REQUEST
  else
    Result := FHttpResponse.StatusCode;
end;

end.
