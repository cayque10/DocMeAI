unit GeminiAPI.Response;

interface

uses
  GeminiAPI.Interfaces;

type
  TGeminiResponse = class(TInterfacedObject, IGeminiResponse)
  private
    FResponse: string;
    constructor Create(const AResponse: string);
    function ExtractTextFromJSON(const AJSONContent: string): string;

  public
    class function New(const AResponse: string): IGeminiResponse;
    function Content: string;
    function Text: string;
  end;

implementation

uses
  System.SysUtils,
  System.JSON,
  System.Generics.Collections;

{ TGeminiResponse }

function TGeminiResponse.Content: string;
begin
  Result := FResponse;
end;

constructor TGeminiResponse.Create(const AResponse: string);
begin
  FResponse := AResponse;
end;

function TGeminiResponse.ExtractTextFromJSON(const AJSONContent: string): string;
var
  lJSONValue: TJSONValue;
  lJSONObject, lCandidate, lContent, lPart: TJSONObject;
  lCandidates, lParts: TJSONArray;
begin
  Result := '';
  lJSONValue := TJSONObject.ParseJSONValue(AJSONContent);
  try
    if not Assigned(lJSONValue) then
      raise Exception.Create('Invalid JSON.');

    if not(lJSONValue is TJSONObject) then
      raise Exception.Create('Unexpected JSON format.');

    lJSONObject := TJSONObject(lJSONValue);

    lCandidates := lJSONObject.GetValue('candidates') as TJSONArray;
    if not Assigned(lCandidates) or (lCandidates.Count = 0) then
      raise Exception.Create('Candidates array not found or empty.');

    lCandidate := lCandidates.Items[0] as TJSONObject;
    if not Assigned(lCandidate) then
      raise Exception.Create('Invalid candidate object.');

    lContent := lCandidate.GetValue('content') as TJSONObject;
    if not Assigned(lContent) then
      raise Exception.Create('Content object not found.');

    lParts := lContent.GetValue('parts') as TJSONArray;
    if not Assigned(lParts) or (lParts.Count = 0) then
      raise Exception.Create('Parts array not found or empty.');

    lPart := lParts.Items[0] as TJSONObject;
    if not Assigned(lPart) then
      raise Exception.Create('Invalid part object.');

    Result := lPart.GetValue('text').Value;
  finally
    lJSONValue.Free;
  end;
end;

class function TGeminiResponse.New(const AResponse: string): IGeminiResponse;
begin
  Result := Self.Create(AResponse);
end;

function TGeminiResponse.Text: string;
begin
  Result := ExtractTextFromJSON(FResponse);
end;

end.
