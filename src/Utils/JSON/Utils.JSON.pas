unit Utils.JSON;

interface

uses
  System.Generics.Collections;

type
  TUtilsJSON = class
  private
  public
    class procedure JSONToEntityList<T: Class, constructor>(const AJSON: String; const AListEntity: TObjectList<T>);
    class function JSONToEntity<T: Class, constructor>(const AJSON: String; const AField: String = ''): T;

  end;

implementation

uses
  System.JSON,
  System.SysUtils,
  Rest.JSON,
  Utils.JSON.Cleaner;

{ TUtilsJSON }

class function TUtilsJSON.JSONToEntity<T>(const AJSON: String; const AField: String = ''): T;
var
  LArray: TJSONArray;
  LValue: TJSONValue;
  LJsonObject: TJSONObject;
  LJsonValueField: TJSONValue;
  LCleanJSON: String;
begin
Result := nil;
  LJsonValueField := nil;

  LValue := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(AJSON), 0);

  if not Assigned(LValue) then
    raise Exception.Create('Objeto JSON inválido!');

  try
    if not LValue.TryGetValue<TJSONArray>('data', LArray) then
    begin
     Exit;
     // raise Exception.Create(Format('Objeto %s não encontrado!', [QuotedStr('Data')]));
    end;

    if LArray.Items[0].ToJSON = 'null' then
      Exit(nil);

    if not AField.Trim.IsEmpty and not LArray.Items[0].TryGetValue<TJSONValue>(AField, LJsonValueField) then
      raise Exception.Create(Format('Objeto %s não encontrado!', [QuotedStr(AField)]));

    if LJsonValueField <> nil then
    begin
      LCleanJSON := TJSONCleaner<T>.New.CleanJSON(LJsonValueField.ToJSON);
      LJsonObject := TJSONObject.ParseJSONValue(LJsonValueField.ToJSON) as TJSONObject
    end
    else
    begin
      LCleanJSON := TJSONCleaner<T>.New.CleanJSON(LArray.Items[0].ToJSON);
      LJsonObject := TJSONObject.ParseJSONValue(LCleanJSON) as TJSONObject;
    end;

    try
      Result := TJSON.JsonToObject<T>(LJsonObject);
    finally
      LJsonObject.Free;
    end;

  finally
    LValue.Free;
  end;
end;

class procedure TUtilsJSON.JSONToEntityList<T>(const AJSON: String; const AListEntity: TObjectList<T>);
var
  LArray: TJSONArray;
  LValue, LValueAux: TJSONValue;
  LJsonObject: TJSONObject;
  LEntity: T;
  LCleanJSON: String;
begin
  if not Assigned(AListEntity) then
    Exit;

  LValueAux := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(AJSON), 0);

  if not Assigned(LValueAux) then
    Exit;

  try
    if not Assigned(LValueAux) then
      raise Exception.Create('Objeto JSON inválido!');

    if not LValueAux.TryGetValue<TJSONArray>('data', LArray) then
    begin
      Exit;
      //raise Exception.Create(Format('Objeto %s não encontrado!', [QuotedStr('Data')]));
    end;

    for LValue in LArray do
    begin
      LCleanJSON := TJSONCleaner<T>.New.CleanJSON(LValue.ToJSON);
      LJsonObject := TJSONObject.ParseJSONValue(LCleanJSON) as TJSONObject;
      try
        LEntity := TJSON.JsonToObject<T>(LJsonObject);
        AListEntity.Add(LEntity);
      finally
        LJsonObject.Free;
      end;
    end;
  finally
    LValueAux.Free;
  end;
end;

end.
