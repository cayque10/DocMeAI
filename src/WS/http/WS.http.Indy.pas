unit WS.Http.Indy;

interface

uses
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  IdSSLOpenSSL, WS.Interfaces, System.Classes;

type
  TWSHttpIndy = class(TInterfacedObject, IWSRequest)
  private
    FHTTPClient: TIdHTTP;
    FIOHandle: TIdSSLIOHandlerSocketOpenSSL;
    FErrorMessage: String;
    FBaseMessage: String;
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
  System.SysUtils,
  IdMultipartFormData;

{ TWSHttpIndy }

procedure TWSHttpIndy.BearerToken(const AToken: String);
begin
  FHTTPClient.Request.CustomHeaders.AddValue('Authorization', 'Bearer ' + AToken);
end;

constructor TWSHttpIndy.Create;
begin
  inherited Create;

  FHTTPClient := TIdHTTP.Create;

  { SSL/TLS }
  FIOHandle := TIdSSLIOHandlerSocketOpenSSL.Create(FHTTPClient);
  FIOHandle.SSLOptions.Method := sslvTLSv1_2;
  FIOHandle.SSLOptions.Mode := sslmClient;
  FHTTPClient.IOHandler := FIOHandle;

  FHTTPClient.Request.ContentType := 'application/json; charset=utf-8';
  FHTTPClient.Request.UserAgent := 'Mozilla/5.0 (compatible;Indy Library)';
  FHTTPClient.Request.Accept := '*/*';
  FHTTPClient.Request.AcceptEncoding := 'gzip, deflate, br';
  FHTTPClient.ConnectTimeout := 60000;
  FHTTPClient.ReadTimeout := 30000;
end;

function TWSHttpIndy.Delete(const AUrl: String; const ASource: TStream): String;
begin
  try
    Result := FHTTPClient.Delete(AUrl);
  except
    on E: EIdHTTPProtocolException do
    begin
      FBaseMessage := E.Message;
      FErrorMessage := E.ErrorMessage;
      raise;
    end;
  end;
end;

destructor TWSHttpIndy.Destroy;
begin
  FHTTPClient.Free;
  inherited;
end;

function TWSHttpIndy.ErrorMessage: String;
begin
  Result := FErrorMessage;
end;

function TWSHttpIndy.Get(const AUrl: String): String;
begin
  try
    Result := FHTTPClient.Get(AUrl);
  except
    on E: EIdHTTPProtocolException do
    begin
      FBaseMessage := E.Message;
      FErrorMessage := E.ErrorMessage;
      raise;
    end;
  end;
end;

function TWSHttpIndy.GetStream(const AUrl: String): TStream;
var
  LStream: TMemoryStream;
begin
  Result := nil;
  LStream := TMemoryStream.Create;
  try
    FHTTPClient.Get(AUrl, LStream);
  except
    on E: EIdHTTPProtocolException do
    begin
      FBaseMessage := E.Message;
      FErrorMessage := E.ErrorMessage;
      LStream.Free;
      raise;
    end;
    on E: Exception do
    begin
      LStream.Free;
      raise;
    end;

  end;
end;

function TWSHttpIndy.HeaderValue(const AName: String): String;
begin
  Result := FHTTPClient.Response.RawHeaders.Values[AName];
end;

function TWSHttpIndy.BaseMessage: String;
begin
  Result := FBaseMessage;
end;

function TWSHttpIndy.Patch(const AUrl: String; const ASource, AResponseContent: TStream): String;
begin
  try
    Result := FHTTPClient.Patch(AUrl, ASource);
  except
    on E: EIdHTTPProtocolException do
    begin
      FBaseMessage := E.Message;
      FErrorMessage := E.ErrorMessage;
      raise;
    end;
  end;
end;

function TWSHttpIndy.Post(const AUrl: String; const ASource: TStream): String;
begin
  try
    Result := FHTTPClient.Post(AUrl, ASource);
  except
    on E: EIdHTTPProtocolException do
    begin
      FBaseMessage := E.Message;
      FErrorMessage := E.ErrorMessage;
      raise;
    end;
  end;
end;

function TWSHttpIndy.PostFile(const AResource, APathFile: String): String;
var
  LParams: TIdMultiPartFormDataStream;
begin
  LParams := TIdMultiPartFormDataStream.Create;
  try
    LParams.AddFile('file', APathFile);
    try
      Result := FHTTPClient.Post(AResource, LParams);
    except
      on E: EIdHTTPProtocolException do
      begin
        FBaseMessage := E.Message;
        FErrorMessage := E.ErrorMessage;
        raise;
      end;
    end;
  finally
    LParams.Free;
  end;
end;

function TWSHttpIndy.Put(const AUrl: String; const ASource: TStream): String;
begin
  try
    Result := FHTTPClient.Put(AUrl, ASource);
  except
    on E: EIdHTTPProtocolException do
    begin
      FBaseMessage := E.Message;
      FErrorMessage := E.ErrorMessage;
      raise;
    end;
  end;
end;

function TWSHttpIndy.ResponseCode: Integer;
begin
  Result := FHTTPClient.ResponseCode;
end;

end.

