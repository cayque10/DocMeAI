unit Utils.JSON.Cleaner;

interface

uses
  System.Rtti,
  System.JSON,
  System.TypInfo,
  System.SysUtils,
  System.Classes,
  System.Generics.Collections;

type
  IJSONCleaner<T: class> = interface
    ['{DB75F095-ADE7-4ABF-8986-F9CCB0FD578D}']
    function CleanJSON(const pJSON: string): string;
  end;

  TJSONCleaner<T: class> = class(TInterfacedObject, IJSONCleaner<T>)
  private
    /// <summary>
    /// Cleans a JSON object by removing fields that are not present in the corresponding class.
    /// </summary>
    /// <param name="LJSONObject">The JSON object to be cleaned.</param>
    /// <param name="LType">The RTTI type of the corresponding Delphi class.</param>
    procedure CleanJSONObject(LJSONObject: TJSONObject; LType: TRttiType);

    /// <summary>
    /// Cleans a JSON array by applying the cleaning process to each item in the array.
    /// </summary>
    /// <param name="LJSONArray">The JSON array to be cleaned.</param>
    /// <param name="LType">The RTTI type of the items in the array.</param>
    procedure CleanJSONArray(LJSONArray: TJSONArray; LType: TRttiType);

    /// <summary>
    /// Obtains the generic type of a list from the RTTI type.
    /// </summary>
    /// <param name="AType">The RTTI type of the TObjectList.</param>
    /// <param name="pTypeListName">The name of the list type.</param>
    /// <returns>The RTTI type of the generic item in the list.</returns>
    function GetGenericClassType(AType: TRttiType; const pTypeListName: String): TRttiType;

    /// <summary>
    /// Removes the prefix 'F' (uppercase or lowercase) from the beginning of a string, if present.
    /// </summary>
    /// <param name="pValue">The string from which the prefix 'F' should be removed.</param>
    /// <returns>
    /// The string without the 'F' prefix at the beginning, if present; otherwise, returns the original string.
    /// </returns>
    function RemovePrefixF(const pValue: string): string;

  public
    /// <summary>
    /// Creates an instance of the class.
    /// </summary>
    /// <returns>
    /// Returns the instance of the class.
    /// </returns>
    class function New: IJSONCleaner<T>;

    /// <summary>
    /// Cleans a JSON string by removing fields that are not present in the corresponding class.
    /// </summary>
    /// <param name="pJSON">The JSON string to be cleaned.</param>
    /// <returns>A cleaned JSON string.</returns>
    function CleanJSON(const pJSON: string): string;

  end;

implementation

uses
  REST.JSON.Types;

procedure TJSONCleaner<T>.CleanJSONObject(LJSONObject: TJSONObject; LType: TRttiType);
var
  LField: TRttiField;
  LContext: TRttiContext;
  LFields: TDictionary<string, TRttiField>;
  LPair: TJSONPair;
  LListToRemove: TList<string>;
  LPairValue: string;
  LJSONPair: TJSONPair;
  LPropType, LPropTypeAux: TRttiType;
  lAttribute: TCustomAttribute;
  lFieldName: String;

begin
  LContext := TRttiContext.Create;
  try
    LFields := TDictionary<string, TRttiField>.Create;
    try
      for LField in LType.GetFields do
      begin
        lFieldName := EmptyStr;

        for lAttribute in LField.GetAttributes do
        begin
          if lAttribute is JSONNameAttribute then
          begin
            lFieldName := JSONNameAttribute(lAttribute).Value;
            break;
          end;
        end;

        if lFieldName.Trim.IsEmpty then
          lFieldName := RemovePrefixF(LField.Name).ToLower;

        LFields.TryAdd(lFieldName.ToLower, LField);
      end;

      LListToRemove := TList<string>.Create;
      try
        for LPair in LJSONObject do
        begin
          if not LFields.ContainsKey(LPair.JsonString.Value.ToLower) then
            LListToRemove.Add(LPair.JsonString.Value)
          else
          begin
            LPropType := LFields[LPair.JsonString.Value.ToLower].FieldType;
            if LPropType.TypeKind = tkClass then
            begin
              if (LPropType.Name.Contains('TList<') or LPropType.Name.Contains('TObjectList<')) and LPropType.IsInstance
              then
              begin
                LPropTypeAux := GetGenericClassType(LPropType, 'System.Generics.Collections.TObjectList<');
                CleanJSONArray(TJSONArray(LPair.JsonValue), LPropTypeAux);
              end
              else
                CleanJSONObject(TJSONObject(LPair.JsonValue), LPropType);
            end
            else if LPropType.TypeKind = tkDynArray then
            begin
              LPropTypeAux := GetGenericClassType(LPropType, 'System.TArray<');
              CleanJSONArray(TJSONArray(LPair.JsonValue), LPropTypeAux);
            end;
          end;
        end;

        for LPairValue in LListToRemove do
        begin
          LJSONPair := LJSONObject.RemovePair(LPairValue);
          if Assigned(LJSONPair) then
            LJSONPair.Free;
        end;
      finally
        LListToRemove.Free;
      end;
    finally
      LFields.Free;
    end;
  finally
    LContext.Free;
  end;
end;

function TJSONCleaner<T>.GetGenericClassType(AType: TRttiType; const pTypeListName: String): TRttiType;
var
  LContext: TRttiContext;
  lRttiType: TRttiType;
  LBaseType: TRttiType;
  LTypeName: string;
  LGenTypeName: string;
begin
  Result := nil;
  LContext := TRttiContext.Create;
  try
    LBaseType := LContext.GetType(AType.Handle);
    if Assigned(LBaseType) then
    begin
      LTypeName := LBaseType.QualifiedName;
      if LTypeName.StartsWith(pTypeListName) then
      begin
        LGenTypeName := Copy(LTypeName, Pos('<', LTypeName) + 1, Length(LTypeName) - Pos('<', LTypeName) - 1);
        lRttiType := LContext.FindType(LGenTypeName);
        Result := lRttiType;
      end;

    end;
  finally
    LContext.Free;
  end;
end;

class function TJSONCleaner<T>.New: IJSONCleaner<T>;
begin
  Result := Self.Create;
end;

function TJSONCleaner<T>.RemovePrefixF(const pValue: string): string;
begin
  if (Length(pValue) > 0) and SameText(pValue[1], 'F') then
    Result := Copy(pValue, 2, Length(pValue) - 1)
  else
    Result := pValue;
end;

procedure TJSONCleaner<T>.CleanJSONArray(LJSONArray: TJSONArray; LType: TRttiType);
var
  LItem: TJSONValue;
  LItemType: TRttiType;
  LContext: TRttiContext;
begin
  if not Assigned(LJSONArray) or (LJSONArray.toJSON.ToLower = 'null') or (LJSONArray.Count <= 0) then
    Exit;

  LContext := TRttiContext.Create;
  try
    for LItem in LJSONArray do
    begin
      if LItem is TJSONObject then
      begin
        LItemType := LContext.GetType(LType.AsInstance.MetaclassType);
        CleanJSONObject(TJSONObject(LItem), LItemType);
      end
      else if LItem is TJSONArray then
      begin
        CleanJSONArray(TJSONArray(LItem), LType);
      end;
    end;
  finally
    LContext.Free;
  end;
end;

function TJSONCleaner<T>.CleanJSON(const pJSON: string): string;
var
  LJSONObject: TJSONObject;
  LContext: TRttiContext;
  LType: TRttiType;
begin
  LJSONObject := TJSONObject.ParseJSONValue(pJSON) as TJSONObject;

  if not Assigned(LJSONObject) then
    raise Exception.Create('Invalid JSON format');

  try
    LContext := TRttiContext.Create;
    try
      LType := LContext.GetType(TClass(T));
      CleanJSONObject(LJSONObject, LType);
      Result := LJSONObject.toJSON;
    finally
      LContext.Free;
    end;
  finally
    LJSONObject.Free;
  end;
end;

end.
