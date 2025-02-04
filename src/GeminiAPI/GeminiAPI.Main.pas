unit GeminiAPI.Main;

interface

uses
  WS.Interfaces,
  GeminiAPI.Interfaces,
  GeminiAPI.GenerativeModels,
  System.Classes;

type


  TGeminiAPI = class(TInterfacedObject, IGeminiAPI)
  private
    FWSBase: IWSBase;
    FAPIKey: string;
    FAPIUrl: string;
    FGenerativeModel: TGeminiModel;
    FPrompt: string;
    constructor Create(const AAPIKey: string);
    function GeminiModelToString(const AModel: TGeminiModel): string;
    function GetAPIURL: string;
    function AddParam(const AName, AValue: string): IGeminiAPI;
    function BuildRequest: TMemoryStream;
  public
    class function New(const AAPIKey: string): IGeminiAPI;
    function GenerativeModel(const AModel: TGeminiModel): IGeminiAPI;
    function Prompt(const AValue: string): IGeminiAPI;
    function Gemini15Pro: IGeminiAPI;
    function Gemini15Flash8B: IGeminiAPI;
    function Gemini15Flash: IGeminiAPI;
    function Gemini20Flash: IGeminiAPI;
    function GenerateContent: IGeminiResponse;
  end;

implementation

uses
  WS.Base,
  System.SysUtils,
  System.JSON,
  System.JSON.Writers,
  System.JSON.Builders, GeminiAPI.Response;

{ TGeminiAPI }

function TGeminiAPI.AddParam(const AName, AValue: string): IGeminiAPI;
begin
  Result := Self;
  FWSBase.Params.Add(Format('%s=%s', [AName, AValue]));
end;

function TGeminiAPI.BuildRequest: TMemoryStream;
var
  lStringWriter: TStringWriter;
  lJSONWriter: TJSONTextWriter;
  lJSONBuilder: TJSONObjectBuilder;
  lJSONString: string;
  lBytes: TBytes;
  lStream: TMemoryStream;
begin
  lStringWriter := TStringWriter.Create;
  try
    lJSONWriter := TJSONTextWriter.Create(lStringWriter);
    try
      lJSONBuilder := TJSONObjectBuilder.Create(lJSONWriter);
      try
        lJSONBuilder.BeginObject.BeginArray('contents').BeginObject.BeginArray('parts').BeginObject.Add('text', FPrompt)
          .EndObject.EndArray.EndObject.EndArray.EndObject;

        lJSONString := lStringWriter.ToString;
      finally
        lJSONBuilder.Free;
      end;
    finally
      lJSONWriter.Free;
    end;
  finally
    lStringWriter.Free;
  end;

  lBytes := TEncoding.UTF8.GetBytes(lJSONString);

  lStream := TMemoryStream.Create;
  try
    lStream.WriteBuffer(lBytes[0], Length(lBytes));
    lStream.Position := 0;
    Result := lStream;
  except
    lStream.Free;
    raise;
  end;
end;

constructor TGeminiAPI.Create(const AAPIKey: string);
begin
  FAPIKey := AAPIKey;
  FAPIUrl := '';
  FGenerativeModel := gmGemini15Flash;
  FWSBase := TWSBase.New;
end;

function TGeminiAPI.Gemini15Flash: IGeminiAPI;
begin
  Result := Self;
  FGenerativeModel := gmGemini15Flash;
end;

function TGeminiAPI.Gemini15Flash8B: IGeminiAPI;
begin
  Result := Self;
  FGenerativeModel := gmGemini15Flash8B;
end;

function TGeminiAPI.Gemini15Pro: IGeminiAPI;
begin
  Result := Self;
  FGenerativeModel := gmGemini15Pro;
end;

function TGeminiAPI.Gemini20Flash: IGeminiAPI;
begin
  Result := Self;
  FGenerativeModel := gmGemini20Flash;
end;

function TGeminiAPI.GeminiModelToString(const AModel: TGeminiModel): string;
begin
  case AModel of
    gmGemini15Flash:
      Result := 'gemini-1.5-flash';
    gmGemini15Flash8B:
      Result := 'gemini-1.5-flash-8b';
    gmGemini15Pro:
      Result := 'gemini-1.5-pro';
    gmGemini20Flash:
      Result := 'gemini-2.0-flash-exp';
  else
    Result := '';
  end;
end;

function TGeminiAPI.GenerateContent: IGeminiResponse;
var
  lRequest: TMemoryStream;
  lResponse: string;
begin
  FAPIUrl := GetAPIURL;
  AddParam('key', FAPIKey);
  lRequest := BuildRequest;
  try
    lResponse := FWSBase.SetBaseUrl(FAPIUrl).WSResquest.Post('', lRequest);

    Result := TGeminiResponse.New(lResponse);
  finally
    lRequest.Free;
  end;
end;

function TGeminiAPI.GenerativeModel(const AModel: TGeminiModel): IGeminiAPI;
begin
  Result := Self;
  FGenerativeModel := AModel;
end;

function TGeminiAPI.GetAPIURL: string;
begin
  Result := 'https://generativelanguage.googleapis.com/v1beta/models/' + GeminiModelToString(FGenerativeModel) +
    ':generateContent';
end;

class function TGeminiAPI.New(const AAPIKey: string): IGeminiAPI;
begin
  Result := Self.Create(AAPIKey);
end;

function TGeminiAPI.Prompt(const AValue: string): IGeminiAPI;
begin
  Result := Self;
  FPrompt := AValue;
end;

end.
